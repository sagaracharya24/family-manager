import 'package:equatable/equatable.dart';

import '../../../domain/entities/scanned_data_entity.dart';

abstract class ScanningState extends Equatable {
  const ScanningState();

  @override
  List<Object?> get props => [];
}

class ScanningInitial extends ScanningState {}

class ScanningLoading extends ScanningState {}

class ScanningSuccess extends ScanningState {
  final ScannedDataEntity scannedData;

  const ScanningSuccess(this.scannedData);

  @override
  List<Object> get props => [scannedData];
}

class ScannedDataLoaded extends ScanningState {
  final List<ScannedDataEntity> scannedDataList;

  const ScannedDataLoaded(this.scannedDataList);

  @override
  List<Object> get props => [scannedDataList];
}

class BarcodeGenerated extends ScanningState {
  final String barcodeData;

  const BarcodeGenerated(this.barcodeData);

  @override
  List<Object> get props => [barcodeData];
}

class ScanningError extends ScanningState {
  final String message;

  const ScanningError(this.message);

  @override
  List<Object> get props => [message];
}