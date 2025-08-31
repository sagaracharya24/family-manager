import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

@lazySingleton
class ApproveUser implements UseCase<UserEntity, ApproveUserParams> {
  final UserRepository repository;

  ApproveUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(ApproveUserParams params) async {
    return await repository.approveUser(params.userId);
  }
}

class ApproveUserParams extends Equatable {
  final String userId;

  const ApproveUserParams({required this.userId});

  @override
  List<Object> get props => [userId];
}