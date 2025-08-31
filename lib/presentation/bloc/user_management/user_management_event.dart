import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class UserManagementEvent extends Equatable {
  const UserManagementEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingUsers extends UserManagementEvent {}

class LoadAllUsers extends UserManagementEvent {}

class ApproveUserRequested extends UserManagementEvent {
  final String userId;

  const ApproveUserRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class RejectUserRequested extends UserManagementEvent {
  final String userId;

  const RejectUserRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateUserRequested extends UserManagementEvent {
  final UserEntity user;

  const CreateUserRequested(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUserRequested extends UserManagementEvent {
  final UserEntity user;

  const UpdateUserRequested(this.user);

  @override
  List<Object> get props => [user];
}