import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/family_member_entity.dart';
import '../../domain/repositories/family_repository.dart';
import '../models/family_member_model.dart';

@LazySingleton(as: FamilyRepository)
class FamilyRepositoryImpl implements FamilyRepository {
  final FirebaseFirestore _firestore;

  FamilyRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, FamilyMemberEntity>> createFamilyMember(FamilyMemberEntity member) async {
    try {
      final memberModel = FamilyMemberModel.fromEntity(member);
      await _firestore
          .collection(AppConstants.familyMembersCollection)
          .doc(member.id)
          .set(memberModel.toJson());
      
      return Right(member);
    } catch (e) {
      return Left(ServerFailure('Failed to create family member: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FamilyMemberEntity>> updateFamilyMember(FamilyMemberEntity member) async {
    try {
      final memberModel = FamilyMemberModel.fromEntity(member);
      await _firestore
          .collection(AppConstants.familyMembersCollection)
          .doc(member.id)
          .update(memberModel.toJson());
      
      return Right(member);
    } catch (e) {
      return Left(ServerFailure('Failed to update family member: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FamilyMemberEntity>>> getFamilyMembers(String homeId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.familyMembersCollection)
          .where('homeId', isEqualTo: homeId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: false)
          .get();

      final members = querySnapshot.docs
          .map((doc) => FamilyMemberModel.fromJson(doc.data()))
          .cast<FamilyMemberEntity>()
          .toList();

      return Right(members);
    } catch (e) {
      return Left(ServerFailure('Failed to get family members: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FamilyMemberEntity>> getFamilyMemberById(String memberId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.familyMembersCollection)
          .doc(memberId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('Family member not found'));
      }
      
      final member = FamilyMemberModel.fromJson(doc.data()!);
      return Right(member);
    } catch (e) {
      return Left(ServerFailure('Failed to get family member: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFamilyMember(String memberId) async {
    try {
      await _firestore
          .collection(AppConstants.familyMembersCollection)
          .doc(memberId)
          .update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete family member: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FamilyMemberEntity>> assignPermissions(String memberId, List<String> permissions) async {
    try {
      await _firestore
          .collection(AppConstants.familyMembersCollection)
          .doc(memberId)
          .update({
        'permissions': permissions,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final updatedMember = await getFamilyMemberById(memberId);
      return updatedMember;
    } catch (e) {
      return Left(ServerFailure('Failed to assign permissions: ${e.toString()}'));
    }
  }

  @override
  Stream<List<FamilyMemberEntity>> getFamilyMembersStream(String homeId) {
    return _firestore
        .collection(AppConstants.familyMembersCollection)
        .where('homeId', isEqualTo: homeId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FamilyMemberModel.fromJson(doc.data()))
            .cast<FamilyMemberEntity>()
            .toList());
  }
}