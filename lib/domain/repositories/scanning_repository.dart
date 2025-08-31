import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/scanned_data_entity.dart';

abstract class ScanningRepository {
  Future<Either<Failure, String>> scanImageForText(String imagePath);
  Future<Either<Failure, Map<String, dynamic>>> scanImageForBarcode(String imagePath);
  Future<Either<Failure, ScannedDataEntity>> saveScannedData(ScannedDataEntity data);
  Future<Either<Failure, List<ScannedDataEntity>>> getScannedDataByUser(String userId);
  Future<Either<Failure, List<ScannedDataEntity>>> getAllScannedData();
  Future<Either<Failure, String>> generateBarcode(Map<String, dynamic> data);
}