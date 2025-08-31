import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object> get props => [];
}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class PendingUsersLoaded extends UserManagementState {
  final List<UserEntity> pendingUsers;

  const PendingUsersLoaded(this.pendingUsers);

  @override
  List<Object> get props => [pendingUsers];
}

class AllUsersLoaded extends UserManagementState {
  final List<UserEntity> users;

  const AllUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserApproved extends UserManagementState {
  final UserEntity user;

  const UserApproved(this.user);

  @override
  List<Object> get props => [user];
}

class UserRejected extends UserManagementState {
  final UserEntity user;

  const UserRejected(this.user);

  @override
  List<Object> get props => [user];
}

class UserCreated extends UserManagementState {
  final UserEntity user;

  const UserCreated(this.user);

  @override
  List<Object> get props => [user];
}

class UserUpdated extends UserManagementState {
  final UserEntity user;

  const UserUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementError extends UserManagementState {
  final String message;

  const UserManagementError(this.message);

  @override
  List<Object> get props => [message];
}