// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScannedDataModel _$ScannedDataModelFromJson(Map<String, dynamic> json) =>
    ScannedDataModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      familyId: json['familyId'] as String,
      imagePath: json['imagePath'] as String,
      extractedText: json['extractedText'] as String,
      structuredData: json['structuredData'] as Map<String, dynamic>,
      barcodeData: json['barcodeData'] as String?,
      barcodeType: json['barcodeType'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ScannedDataModelToJson(ScannedDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'familyId': instance.familyId,
      'imagePath': instance.imagePath,
      'extractedText': instance.extractedText,
      'structuredData': instance.structuredData,
      'barcodeData': instance.barcodeData,
      'barcodeType': instance.barcodeType,
      'scannedAt': instance.scannedAt.toIso8601String(),
      'metadata': instance.metadata,
    };
