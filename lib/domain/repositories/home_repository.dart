import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeEntity>> createHome(HomeEntity home);
  Future<Either<Failure, HomeEntity>> updateHome(HomeEntity home);
  Future<Either<Failure, List<HomeEntity>>> getHomesByAdminId(String adminId);
  Future<Either<Failure, HomeEntity>> getHomeById(String homeId);
  Future<Either<Failure, void>> deleteHome(String homeId);
  Stream<List<HomeEntity>> getHomesByAdminIdStream(String adminId);
}