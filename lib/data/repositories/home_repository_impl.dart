import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/home_model.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, HomeEntity>> createHome(HomeEntity home) async {
    try {
      print('HomeRepository: Creating home in Firestore: ${home.name}');
      final homeModel = HomeModel.fromEntity(home);
      print('HomeRepository: Home model JSON: ${homeModel.toJson()}');
      
      await _firestore
          .collection(AppConstants.homesCollection)
          .doc(home.id)
          .set(homeModel.toJson());
      
      print('HomeRepository: Home created successfully in Firestore');
      return Right(home);
    } catch (e) {
      print('HomeRepository: Error creating home: ${e.toString()}');
      return Left(ServerFailure('Failed to create home: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, HomeEntity>> updateHome(HomeEntity home) async {
    try {
      final homeModel = HomeModel.fromEntity(home);
      await _firestore
          .collection(AppConstants.homesCollection)
          .doc(home.id)
          .update(homeModel.toJson());
      
      return Right(home);
    } catch (e) {
      return Left(ServerFailure('Failed to update home: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getHomesByAdminId(String adminId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.homesCollection)
          .where('adminId', isEqualTo: adminId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: false)
          .get();

      final homes = querySnapshot.docs
          .map((doc) => HomeModel.fromJson(doc.data()))
          .cast<HomeEntity>()
          .toList();

      return Right(homes);
    } catch (e) {
      return Left(ServerFailure('Failed to get homes: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, HomeEntity>> getHomeById(String homeId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.homesCollection)
          .doc(homeId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('Home not found'));
      }
      
      final home = HomeModel.fromJson(doc.data()!);
      return Right(home);
    } catch (e) {
      return Left(ServerFailure('Failed to get home: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHome(String homeId) async {
    try {
      await _firestore
          .collection(AppConstants.homesCollection)
          .doc(homeId)
          .update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete home: ${e.toString()}'));
    }
  }

  @override
  Stream<List<HomeEntity>> getHomesByAdminIdStream(String adminId) {
    return _firestore
        .collection(AppConstants.homesCollection)
        .where('adminId', isEqualTo: adminId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HomeModel.fromJson(doc.data()))
            .cast<HomeEntity>()
            .toList());
  }
}