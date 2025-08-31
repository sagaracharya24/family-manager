import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/auth/authenticate_with_biometrics.dart';
import '../../../domain/usecases/auth/sign_in_with_google.dart';
import '../../../domain/usecases/auth/sign_in_with_phone.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithPhone _signInWithPhone;
  final AuthenticateWithBiometrics _authenticateWithBiometrics;
  final AuthRepository _authRepository;
  
  bool _pendingPhoneIsSuperAdmin = false;

  AuthBloc(
    this._signInWithGoogle,
    this._signInWithPhone,
    this._authenticateWithBiometrics,
    this._authRepository,
  ) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<PhoneSignInRequested>(_onPhoneSignInRequested);
    on<PhoneVerificationRequested>(_onPhoneVerificationRequested);
    on<BiometricAuthRequested>(_onBiometricAuthRequested);
    on<BiometricAuthSkipped>(_onBiometricAuthSkipped);
    on<SignOutRequested>(_onSignOutRequested);
    on<UserApprovalStatusChanged>(_onUserApprovalStatusChanged);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.getCurrentUser();
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user == null) {
          emit(AuthUnauthenticated());
        } else {
          if (user.status == AppConstants.userStatusPending) {
            emit(AuthPendingApproval(user));
          } else if (user.status == AppConstants.userStatusApproved) {
            emit(BiometricAuthRequired(user));
          } else {
            emit(AuthRejected('Your account has been rejected'));
          }
        }
      },
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.signInWithGoogle();
    
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) {
        if (user.role == AppConstants.roleSuperAdmin) {
          emit(AuthAuthenticated(user));
        } else if (user.status == AppConstants.userStatusPending) {
          emit(AuthPendingApproval(user));
        } else if (user.status == AppConstants.userStatusApproved) {
          emit(BiometricAuthRequired(user));
        } else {
          emit(AuthRejected('Your account has been rejected'));
        }
      },
    );
  }

  Future<void> _onPhoneSignInRequested(
    PhoneSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.signInWithPhoneNumber(event.phoneNumber);
    
    result.fold(
      (failure) {
        if (failure.toString().contains('VERIFICATION_CODE_SENT')) {
          emit(PhoneVerificationCodeSent(event.phoneNumber));
        } else {
          emit(AuthError(failure.toString()));
        }
      },
      (user) {
        if (user.role == AppConstants.roleSuperAdmin) {
          emit(AuthAuthenticated(user));
        } else if (user.status == AppConstants.userStatusPending) {
          emit(AuthPendingApproval(user));
        } else if (user.status == AppConstants.userStatusApproved) {
          emit(BiometricAuthRequired(user));
        } else {
          emit(AuthRejected('Your account has been rejected'));
        }
      },
    );
  }

  Future<void> _onPhoneVerificationRequested(
    PhoneVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _authRepository.verifyPhoneNumber(event.verificationCode);
    
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) {
        if (user.role == AppConstants.roleSuperAdmin) {
          emit(AuthAuthenticated(user));
        } else if (user.status == AppConstants.userStatusPending) {
          emit(AuthPendingApproval(user));
        } else if (user.status == AppConstants.userStatusApproved) {
          emit(BiometricAuthRequired(user));
        } else {
          emit(AuthRejected('Your account has been rejected'));
        }
      },
    );
  }

  Future<void> _onBiometricAuthRequested(
    BiometricAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! BiometricAuthRequired) return;
    
    final user = (state as BiometricAuthRequired).user;
    
    final result = await _authenticateWithBiometrics(NoParams());
    
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (isAuthenticated) {
        if (isAuthenticated) {
          emit(AuthAuthenticated(user));
        } else {
          emit(BiometricAuthRequired(user));
        }
      },
    );
  }

  Future<void> _onBiometricAuthSkipped(
    BiometricAuthSkipped event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! BiometricAuthRequired) return;
    
    final user = (state as BiometricAuthRequired).user;
    emit(AuthAuthenticated(user));
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    emit(AuthUnauthenticated());
  }

  Future<void> _onUserApprovalStatusChanged(
    UserApprovalStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthPendingApproval) {
      final user = (state as AuthPendingApproval).user;
      
      if (event.status == AppConstants.userStatusApproved) {
        emit(BiometricAuthRequired(user));
      } else if (event.status == AppConstants.userStatusRejected) {
        emit(AuthRejected('Your account has been rejected'));
      }
    }
  }
}