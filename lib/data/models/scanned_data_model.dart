import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/scanned_data_entity.dart';

part 'scanned_data_model.g.dart';

@JsonSerializable()
class ScannedDataModel extends ScannedDataEntity {
  const ScannedDataModel({
    required super.id,
    required super.userId,
    required super.familyId,
    required super.imagePath,
    required super.extractedText,
    required super.structuredData,
    super.barcodeData,
    super.barcodeType,
    required super.scannedAt,
    super.metadata,
  });

  factory ScannedDataModel.fromJson(Map<String, dynamic> json) => _$ScannedDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScannedDataModelToJson(this);

  factory ScannedDataModel.fromEntity(ScannedDataEntity entity) {
    return ScannedDataModel(
      id: entity.id,
      userId: entity.userId,
      familyId: entity.familyId,
      imagePath: entity.imagePath,
      extractedText: entity.extractedText,
      structuredData: entity.structuredData,
      barcodeData: entity.barcodeData,
      barcodeType: entity.barcodeType,
      scannedAt: entity.scannedAt,
      metadata: entity.metadata,
    );
  }
}