import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/home_entity.dart';
import '../../repositories/home_repository.dart';

@injectable
class GetUserHomes implements UseCase<List<HomeEntity>, GetUserHomesParams> {
  final HomeRepository repository;

  GetUserHomes(this.repository);

  @override
  Future<Either<Failure, List<HomeEntity>>> call(GetUserHomesParams params) async {
    return await repository.getHomesByAdminId(params.adminId);
  }
}

class GetUserHomesParams {
  final String adminId;

  GetUserHomesParams({required this.adminId});
}