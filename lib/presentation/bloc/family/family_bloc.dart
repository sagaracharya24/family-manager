import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/family/get_family_members.dart';
import 'family_event.dart';
import 'family_state.dart';

@injectable
class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final GetFamilyMembers _getFamilyMembers;

  FamilyBloc(
    this._getFamilyMembers,
  ) : super(FamilyInitial()) {
    on<LoadFamilyMembers>(_onLoadFamilyMembers);
    on<AddFamilyMember>(_onAddFamilyMember);
    on<UpdateFamilyMember>(_onUpdateFamilyMember);
    on<RemoveFamilyMember>(_onRemoveFamilyMember);
    on<UpdatePermissions>(_onUpdatePermissions);
  }

  Future<void> _onLoadFamilyMembers(
    LoadFamilyMembers event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    
    final result = await _getFamilyMembers(GetFamilyMembersParams(familyId: event.familyId));
    
    result.fold(
      (failure) => emit(FamilyError(failure.toString())),
      (members) => emit(FamilyMembersLoaded(members)),
    );
  }

  Future<void> _onAddFamilyMember(
    AddFamilyMember event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    // TODO: Implement add family member use case
    emit(const FamilyError('Add family member not implemented yet'));
  }

  Future<void> _onUpdateFamilyMember(
    UpdateFamilyMember event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    // TODO: Implement update family member use case
    emit(const FamilyError('Update family member not implemented yet'));
  }

  Future<void> _onRemoveFamilyMember(
    RemoveFamilyMember event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    // TODO: Implement remove family member use case
    emit(const FamilyError('Remove family member not implemented yet'));
  }

  Future<void> _onUpdatePermissions(
    UpdatePermissions event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    // TODO: Implement update permissions use case
    emit(const FamilyError('Update permissions not implemented yet'));
  }
}