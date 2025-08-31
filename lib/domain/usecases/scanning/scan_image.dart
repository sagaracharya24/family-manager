import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/scanned_data_entity.dart';
import '../../repositories/scanning_repository.dart';

@lazySingleton
class ScanImage implements UseCase<ScannedDataEntity, ScanImageParams> {
  final ScanningRepository repository;

  ScanImage(this.repository);

  @override
  Future<Either<Failure, ScannedDataEntity>> call(ScanImageParams params) async {
    // First scan for text
    final textResult = await repository.scanImageForText(params.imagePath);
    if (textResult.isLeft()) {
      return Left(textResult.fold((l) => l, (r) => throw Exception()));
    }

    // Scan for barcode
    final barcodeResult = await repository.scanImageForBarcode(params.imagePath);
    
    final extractedText = textResult.fold((l) => '', (r) => r);
    final barcodeData = barcodeResult.fold((l) => null, (r) => r);

    final scannedData = ScannedDataEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: params.userId,
      familyId: params.familyId,
      imagePath: params.imagePath,
      extractedText: extractedText,
      structuredData: {'text': extractedText, 'barcode': barcodeData},
      barcodeData: barcodeData?['data'],
      barcodeType: barcodeData?['type'],
      scannedAt: DateTime.now(),
      metadata: params.metadata,
    );

    return await repository.saveScannedData(scannedData);
  }
}

class ScanImageParams extends Equatable {
  final String imagePath;
  final String userId;
  final String familyId;
  final Map<String, dynamic>? metadata;

  const ScanImageParams({
    required this.imagePath,
    required this.userId,
    required this.familyId,
    this.metadata,
  });

  @override
  List<Object?> get props => [imagePath, userId, familyId, metadata];
}