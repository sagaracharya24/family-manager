import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/user/approve_user.dart';
import '../../../domain/usecases/user/get_pending_users.dart';
import '../../../domain/usecases/user/reject_user.dart';
import 'user_management_event.dart';
import 'user_management_state.dart';

@injectable
class UserManagementBloc extends Bloc<UserManagementEvent, UserManagementState> {
  final ApproveUser _approveUser;
  final RejectUser _rejectUser;
  final GetPendingUsers _getPendingUsers;

  UserManagementBloc(
    this._approveUser,
    this._rejectUser,
    this._getPendingUsers,
  ) : super(UserManagementInitial()) {
    on<LoadPendingUsers>(_onLoadPendingUsers);
    on<LoadAllUsers>(_onLoadAllUsers);
    on<ApproveUserRequested>(_onApproveUserRequested);
    on<RejectUserRequested>(_onRejectUserRequested);
    on<CreateUserRequested>(_onCreateUserRequested);
    on<UpdateUserRequested>(_onUpdateUserRequested);
  }

  Future<void> _onLoadPendingUsers(
    LoadPendingUsers event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());
    
    final result = await _getPendingUsers(NoParams());
    
    result.fold(
      (failure) => emit(UserManagementError(failure.toString())),
      (users) => emit(PendingUsersLoaded(users)),
    );
  }

  Future<void> _onLoadAllUsers(
    LoadAllUsers event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());
    // TODO: Implement get all users use case
    emit(const AllUsersLoaded([]));
  }

  Future<void> _onApproveUserRequested(
    ApproveUserRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());
    
    final result = await _approveUser(ApproveUserParams(userId: event.userId));
    
    result.fold(
      (failure) => emit(UserManagementError(failure.toString())),
      (user) => emit(UserApproved(user)),
    );
  }

  Future<void> _onRejectUserRequested(
    RejectUserRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());
    
    final result = await _rejectUser(RejectUserParams(userId: event.userId));
    
    result.fold(
      (failure) => emit(UserManagementError(failure.toString())),
      (user) => emit(UserRejected(user)),
    );
  }

  Future<void> _onCreateUserRequested(
    CreateUserRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());
    // TODO: Implement create user use case
  }

  Future<void> _onUpdateUserRequested(
    UpdateUserRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());
    // TODO: Implement update user use case
  }
}