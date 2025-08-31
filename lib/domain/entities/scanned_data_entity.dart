import 'package:equatable/equatable.dart';

class ScannedDataEntity extends Equatable {
  final String id;
  final String userId;
  final String familyId;
  final String imagePath;
  final String extractedText;
  final Map<String, dynamic> structuredData;
  final String? barcodeData;
  final String? barcodeType;
  final DateTime scannedAt;
  final Map<String, dynamic>? metadata;

  const ScannedDataEntity({
    required this.id,
    required this.userId,
    required this.familyId,
    required this.imagePath,
    required this.extractedText,
    required this.structuredData,
    this.barcodeData,
    this.barcodeType,
    required this.scannedAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        familyId,
        imagePath,
        extractedText,
        structuredData,
        barcodeData,
        barcodeType,
        scannedAt,
        metadata,
      ];
}