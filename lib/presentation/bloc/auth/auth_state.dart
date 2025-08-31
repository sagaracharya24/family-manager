import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthPendingApproval extends AuthState {
  final UserEntity user;

  const AuthPendingApproval(this.user);

  @override
  List<Object> get props => [user];
}

class AuthRejected extends AuthState {
  final String message;

  const AuthRejected(this.message);

  @override
  List<Object> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class BiometricAuthRequired extends AuthState {
  final UserEntity user;

  const BiometricAuthRequired(this.user);

  @override
  List<Object> get props => [user];
}

class PhoneVerificationCodeSent extends AuthState {
  final String phoneNumber;

  const PhoneVerificationCodeSent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}