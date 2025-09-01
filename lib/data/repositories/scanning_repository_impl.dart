import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
// import 'package:google_ml_kit/google_ml_kit.dart'; // Temporarily disabled
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/scanned_data_entity.dart';
import '../../domain/repositories/scanning_repository.dart';
import '../models/scanned_data_model.dart';

@LazySingleton(as: ScanningRepository)
class ScanningRepositoryImpl implements ScanningRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ScanningRepositoryImpl(this._firestore, this._storage);

  @override
  Future<Either<Failure, String>> scanImageForText(String imagePath) async {
    // TODO: Re-enable when google_ml_kit is available
    return Left(ServerFailure('Text scanning temporarily disabled - google_ml_kit package not available'));
    
    // try {
    //   final inputImage = InputImage.fromFilePath(imagePath);
    //   final textRecognizer = TextRecognizer();
    //   
    //   final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    //   
    //   await textRecognizer.close();
    //   
    //   return Right(recognizedText.text);
    // } catch (e) {
    //   return Left(ServerFailure('Failed to scan text: ${e.toString()}'));
    // }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> scanImageForBarcode(String imagePath) async {
    // TODO: Re-enable when google_ml_kit is available
    return Left(ServerFailure('Barcode scanning temporarily disabled - google_ml_kit package not available'));
    
    // try {
    //   final inputImage = InputImage.fromFilePath(imagePath);
    //   final barcodeScanner = BarcodeScanner();
    //   
    //   final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
    //   
    //   await barcodeScanner.close();
    //   
    //   if (barcodes.isNotEmpty) {
    //     final barcode = barcodes.first;
    //     return Right({
    //       'data': barcode.displayValue ?? barcode.rawValue ?? '',
    //       'type': barcode.type.toString(),
    //       'format': barcode.format.toString(),
    //     });
    //   }
    //   
    //   return const Right({});
    // } catch (e) {
    //   return Left(ServerFailure('Failed to scan barcode: ${e.toString()}'));
    // }
  }

  @override
  Future<Either<Failure, ScannedDataEntity>> saveScannedData(ScannedDataEntity data) async {
    try {
      // Upload image to Firebase Storage
      String? uploadedImageUrl;
      if (data.imagePath.isNotEmpty) {
        final imageFile = File(data.imagePath);
        if (await imageFile.exists()) {
          // Validate image file format
          final extension = data.imagePath.toLowerCase().split('.').last;
          if (!['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
            return Left(ServerFailure('Invalid image format. Supported formats: jpg, jpeg, png, gif, bmp, webp'));
          }
          
          try {
            final storageRef = _storage
                .ref()
                .child(AppConstants.scannedImagesPath)
                .child('${data.userId}_${data.id}.jpg');
            
            final uploadTask = await storageRef.putFile(imageFile);
            uploadedImageUrl = await uploadTask.ref.getDownloadURL();
          } catch (storageError) {
            return Left(ServerFailure('Failed to upload image: ${storageError.toString()}'));
          }
        }
      }
      
      // Create updated entity with Firebase Storage URL
      final updatedData = ScannedDataEntity(
        id: data.id,
        userId: data.userId,
        familyId: data.familyId,
        imagePath: uploadedImageUrl ?? data.imagePath,
        extractedText: data.extractedText,
        structuredData: data.structuredData,
        barcodeData: data.barcodeData,
        barcodeType: data.barcodeType,
        scannedAt: data.scannedAt,
        metadata: data.metadata,
      );
      
      final model = ScannedDataModel.fromEntity(updatedData);
      await _firestore
          .collection(AppConstants.scannedDataCollection)
          .doc(data.id)
          .set(model.toJson());
      
      return Right(updatedData);
    } catch (e) {
      return Left(ServerFailure('Failed to save scanned data: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ScannedDataEntity>>> getScannedDataByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.scannedDataCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('scannedAt', descending: true)
          .get();

      final scannedData = querySnapshot.docs
          .map((doc) => ScannedDataModel.fromJson(doc.data()) as ScannedDataEntity)
          .toList();

      return Right(scannedData);
    } catch (e) {
      return Left(ServerFailure('Failed to get scanned data: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ScannedDataEntity>>> getAllScannedData() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.scannedDataCollection)
          .orderBy('scannedAt', descending: true)
          .get();

      final scannedData = querySnapshot.docs
          .map((doc) => ScannedDataModel.fromJson(doc.data()) as ScannedDataEntity)
          .toList();

      return Right(scannedData);
    } catch (e) {
      return Left(ServerFailure('Failed to get all scanned data: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> generateBarcode(Map<String, dynamic> data) async {
    try {
      final barcodeData = data['data'] as String? ?? '';
      final barcodeType = data['type'] as String? ?? 'QR';
      
      if (barcodeData.isEmpty) {
        return Left(ServerFailure('Barcode data cannot be empty'));
      }
      
      // Create barcode widget
      final barcodeWidget = BarcodeWidget(
        barcode: barcodeType.toLowerCase() == 'qr' ? Barcode.qrCode() : Barcode.code128(),
        data: barcodeData,
        width: 200,
        height: 200,
      );
      
      // Convert widget to image and save
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/barcode_${DateTime.now().millisecondsSinceEpoch}.png';
      
      // For now, return the data as the barcode generation requires UI context
      // This should be handled in the presentation layer
      return Right(barcodeData);
    } catch (e) {
      return Left(ServerFailure('Failed to generate barcode: ${e.toString()}'));
    }
  }
}