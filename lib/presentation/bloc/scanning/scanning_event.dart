import 'package:equatable/equatable.dart';

abstract class ScanningEvent extends Equatable {
  const ScanningEvent();

  @override
  List<Object?> get props => [];
}

class ScanImageRequested extends ScanningEvent {
  final String imagePath;
  final String userId;
  final String familyId;
  final Map<String, dynamic>? metadata;

  const ScanImageRequested({
    required this.imagePath,
    required this.userId,
    required this.familyId,
    this.metadata,
  });

  @override
  List<Object?> get props => [imagePath, userId, familyId, metadata];
}

class GetScannedDataRequested extends ScanningEvent {
  final String? userId;

  const GetScannedDataRequested({this.userId});

  @override
  List<Object?> get props => [userId];
}

class GenerateBarcodeRequested extends ScanningEvent {
  final Map<String, dynamic> data;

  const GenerateBarcodeRequested(this.data);

  @override
  List<Object> get props => [data];
}