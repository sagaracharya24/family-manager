import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

@lazySingleton
class GetPendingUsers implements UseCase<List<UserEntity>, NoParams> {
  final UserRepository repository;

  GetPendingUsers(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async {
    return await repository.getPendingUsers();
  }
}