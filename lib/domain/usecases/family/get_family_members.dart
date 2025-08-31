import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/family_member_entity.dart';
import '../../repositories/family_repository.dart';

@injectable
class GetFamilyMembers implements UseCase<List<FamilyMemberEntity>, GetFamilyMembersParams> {
  final FamilyRepository repository;

  GetFamilyMembers(this.repository);

  @override
  Future<Either<Failure, List<FamilyMemberEntity>>> call(GetFamilyMembersParams params) async {
    return await repository.getFamilyMembers(params.familyId);
  }
}

class GetFamilyMembersParams {
  final String familyId;

  GetFamilyMembersParams({required this.familyId});
}