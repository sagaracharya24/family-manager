import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:injectable/injectable.dart';

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
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final textRecognizer = TextRecognizer();
      
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      await textRecognizer.close();
      
      return Right(recognizedText.text);
    } catch (e) {
      return Left(ServerFailure('Failed to scan text: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> scanImageForBarcode(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final barcodeScanner = BarcodeScanner();
      
      final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
      
      await barcodeScanner.close();
      
      if (barcodes.isNotEmpty) {
        final barcode = barcodes.first;
        return Right({
          'data': barcode.displayValue ?? barcode.rawValue ?? '',
          'type': barcode.type.toString(),
          'format': barcode.format.toString(),
        });
      }
      
      return const Right({});
    } catch (e) {
      return Left(ServerFailure('Failed to scan barcode: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ScannedDataEntity>> saveScannedData(ScannedDataEntity data) async {
    try {
      // Upload image to Firebase Storage
      String? uploadedImageUrl;
      if (data.imagePath.isNotEmpty) {
        final imageFile = File(data.imagePath);
        if (await imageFile.exists()) {
          final storageRef = _storage
              .ref()
              .child(AppConstants.scannedImagesPath)
              .child('${data.userId}_${data.id}.jpg');
          
          final uploadTask = await storageRef.putFile(imageFile);
          uploadedImageUrl = await uploadTask.ref.getDownloadURL();
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
          .map((doc) => ScannedDataModel.fromJson(doc.data()))
          .cast<ScannedDataEntity>()
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
          .map((doc) => ScannedDataModel.fromJson(doc.data()))
          .cast<ScannedDataEntity>()
          .toList();

      return Right(scannedData);
    } catch (e) {
      return Left(ServerFailure('Failed to get all scanned data: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> generateBarcode(Map<String, dynamic> data) async {
    try {
      // This would return a path to generated barcode image
      // Implementation depends on specific barcode generation requirements
      final barcodeData = data.toString();
      return Right(barcodeData);
    } catch (e) {
      return Left(ServerFailure('Failed to generate barcode: ${e.toString()}'));
    }
  }
}