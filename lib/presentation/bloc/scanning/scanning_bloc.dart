import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/scanning/scan_image.dart';
import 'scanning_event.dart';
import 'scanning_state.dart';

@injectable
class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  final ScanImage _scanImage;

  ScanningBloc(this._scanImage) : super(ScanningInitial()) {
    on<ScanImageRequested>(_onScanImageRequested);
    on<GetScannedDataRequested>(_onGetScannedDataRequested);
    on<GenerateBarcodeRequested>(_onGenerateBarcodeRequested);
  }

  Future<void> _onScanImageRequested(
    ScanImageRequested event,
    Emitter<ScanningState> emit,
  ) async {
    emit(ScanningLoading());

    final params = ScanImageParams(
      imagePath: event.imagePath,
      userId: event.userId,
      familyId: event.familyId,
      metadata: event.metadata,
    );

    final result = await _scanImage(params);

    result.fold(
      (failure) => emit(ScanningError(failure.toString())),
      (scannedData) => emit(ScanningSuccess(scannedData)),
    );
  }

  Future<void> _onGetScannedDataRequested(
    GetScannedDataRequested event,
    Emitter<ScanningState> emit,
  ) async {
    emit(ScanningLoading());
    // Implementation for getting scanned data
  }

  Future<void> _onGenerateBarcodeRequested(
    GenerateBarcodeRequested event,
    Emitter<ScanningState> emit,
  ) async {
    emit(ScanningLoading());
    // Implementation for barcode generation
  }
}