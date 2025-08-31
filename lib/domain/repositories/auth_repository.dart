import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle({bool isSuperAdmin = false});
  Future<Either<Failure, UserEntity>> signInWithPhoneNumber(String phoneNumber, {bool isSuperAdmin = false});
  Future<Either<Failure, UserEntity>> verifyPhoneNumber(String verificationCode);
  Future<Either<Failure, bool>> authenticateWithBiometrics();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
}