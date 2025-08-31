import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/home_entity.dart';
import '../../repositories/home_repository.dart';

@injectable
class CreateHome implements UseCase<HomeEntity, CreateHomeParams> {
  final HomeRepository repository;

  CreateHome(this.repository);

  @override
  Future<Either<Failure, HomeEntity>> call(CreateHomeParams params) async {
    final home = HomeEntity(
      id: params.id,
      name: params.name,
      description: params.description,
      adminId: params.adminId,
      address: params.address,
      photoUrl: params.photoUrl,
      memberIds: const [],
      isActive: true,
      createdAt: DateTime.now(),
    );
    
    return await repository.createHome(home);
  }
}

class CreateHomeParams {
  final String id;
  final String name;
  final String description;
  final String adminId;
  final String? address;
  final String? photoUrl;

  CreateHomeParams({
    required this.id,
    required this.name,
    required this.description,
    required this.adminId,
    this.address,
    this.photoUrl,
  });
}