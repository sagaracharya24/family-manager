import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {
  final bool isSuperAdmin;

  const GoogleSignInRequested(this.isSuperAdmin);

  @override
  List<Object> get props => [isSuperAdmin];
}

class PhoneSignInRequested extends AuthEvent {
  final String phoneNumber;
  final bool isSuperAdmin;

  const PhoneSignInRequested(this.phoneNumber, this.isSuperAdmin);

  @override
  List<Object> get props => [phoneNumber, isSuperAdmin];
}

class BiometricAuthRequested extends AuthEvent {}

class BiometricAuthSkipped extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class PhoneVerificationRequested extends AuthEvent {
  final String verificationCode;

  const PhoneVerificationRequested(this.verificationCode);

  @override
  List<Object> get props => [verificationCode];
}

class UserApprovalStatusChanged extends AuthEvent {
  final String status;

  const UserApprovalStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}