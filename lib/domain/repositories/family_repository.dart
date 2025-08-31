import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/family_member_entity.dart';

abstract class FamilyRepository {
  Future<Either<Failure, FamilyMemberEntity>> createFamilyMember(FamilyMemberEntity member);
  Future<Either<Failure, FamilyMemberEntity>> updateFamilyMember(FamilyMemberEntity member);
  Future<Either<Failure, List<FamilyMemberEntity>>> getFamilyMembers(String familyId);
  Future<Either<Failure, FamilyMemberEntity>> getFamilyMemberById(String memberId);
  Future<Either<Failure, void>> deleteFamilyMember(String memberId);
  Future<Either<Failure, FamilyMemberEntity>> assignPermissions(String memberId, List<String> permissions);
}