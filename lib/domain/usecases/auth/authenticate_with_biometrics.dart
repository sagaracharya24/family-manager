import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/auth_repository.dart';

@lazySingleton
class AuthenticateWithBiometrics implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  AuthenticateWithBiometrics(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.authenticateWithBiometrics();
  }
}