import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, UserEntity>> createUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(userModel.toJson());
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to create user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .update(userModel.toJson());
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to update user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('User not found'));
      }
      
      final user = UserModel.fromJson(doc.data()!);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to get user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getPendingUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .where('status', isEqualTo: AppConstants.userStatusPending)
          .orderBy('createdAt', descending: true)
          .get();

      final users = querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .cast<UserEntity>()
          .toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure('Failed to get pending users: ${e.toString()}'));
    }
  }

  @override
  Stream<List<UserEntity>> getPendingUsersStream() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('status', isEqualTo: AppConstants.userStatusPending)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .cast<UserEntity>()
            .toList());
  }

  @override
  Stream<List<UserEntity>> getAllUsersStream() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .cast<UserEntity>()
            .toList());
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      final users = querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .cast<UserEntity>()
          .toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure('Failed to get all users: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> approveUser(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'status': AppConstants.userStatusApproved,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final updatedUser = await getUserById(userId);
      return updatedUser;
    } catch (e) {
      return Left(ServerFailure('Failed to approve user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> rejectUser(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'status': AppConstants.userStatusRejected,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final updatedUser = await getUserById(userId);
      return updatedUser;
    } catch (e) {
      return Left(ServerFailure('Failed to reject user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .delete();
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete user: ${e.toString()}'));
    }
  }
}