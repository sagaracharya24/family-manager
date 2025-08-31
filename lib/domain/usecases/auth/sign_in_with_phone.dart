import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

@lazySingleton
class SignInWithPhone implements UseCase<UserEntity, SignInWithPhoneParams> {
  final AuthRepository repository;

  SignInWithPhone(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInWithPhoneParams params) async {
    return await repository.signInWithPhoneNumber(params.phoneNumber);
  }
}

class SignInWithPhoneParams extends Equatable {
  final String phoneNumber;

  const SignInWithPhoneParams({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}