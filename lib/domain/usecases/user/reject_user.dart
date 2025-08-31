import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

@lazySingleton
class RejectUser implements UseCase<UserEntity, RejectUserParams> {
  final UserRepository repository;

  RejectUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RejectUserParams params) async {
    return await repository.rejectUser(params.userId);
  }
}

class RejectUserParams extends Equatable {
  final String userId;

  const RejectUserParams({required this.userId});

  @override
  List<Object> get props => [userId];
}