import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> createUser(UserEntity user);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, UserEntity>> getUserById(String userId);
  Future<Either<Failure, List<UserEntity>>> getPendingUsers();
  Stream<List<UserEntity>> getPendingUsersStream();
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Stream<List<UserEntity>> getAllUsersStream();
  Future<Either<Failure, UserEntity>> approveUser(String userId);
  Future<Either<Failure, UserEntity>> rejectUser(String userId);
  Future<Either<Failure, void>> deleteUser(String userId);
}