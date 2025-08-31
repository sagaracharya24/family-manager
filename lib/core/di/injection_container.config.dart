// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../data/repositories/family_repository_impl.dart' as _i1059;
import '../../data/repositories/scanning_repository_impl.dart' as _i879;
import '../../data/repositories/user_repository_impl.dart' as _i790;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../domain/repositories/family_repository.dart' as _i866;
import '../../domain/repositories/scanning_repository.dart' as _i858;
import '../../domain/repositories/user_repository.dart' as _i271;
import '../../domain/usecases/auth/authenticate_with_biometrics.dart' as _i93;
import '../../domain/usecases/auth/sign_in_with_google.dart' as _i777;
import '../../domain/usecases/auth/sign_in_with_phone.dart' as _i879;
import '../../domain/usecases/scanning/scan_image.dart' as _i303;
import '../../domain/usecases/user/approve_user.dart' as _i700;
import '../../domain/usecases/user/get_pending_users.dart' as _i742;
import '../../domain/usecases/user/reject_user.dart' as _i208;
import '../../presentation/bloc/auth/auth_bloc.dart' as _i605;
import '../../presentation/bloc/scanning/scanning_bloc.dart' as _i339;
import '../../presentation/bloc/user_management/user_management_bloc.dart'
    as _i282;
import '../services/notification_service.dart' as _i941;
import 'injection_container.dart' as _i809;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i457.FirebaseStorage>(
        () => registerModule.firebaseStorage);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i941.NotificationService>(
        () => _i941.NotificationService());
    gh.lazySingleton<_i1073.AuthRepository>(() => _i895.AuthRepositoryImpl(
          gh<_i59.FirebaseAuth>(),
          gh<_i116.GoogleSignIn>(),
          gh<_i974.FirebaseFirestore>(),
        ));
    gh.lazySingleton<_i271.UserRepository>(
        () => _i790.UserRepositoryImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i866.FamilyRepository>(
        () => _i1059.FamilyRepositoryImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i93.AuthenticateWithBiometrics>(
        () => _i93.AuthenticateWithBiometrics(gh<_i1073.AuthRepository>()));
    gh.lazySingleton<_i777.SignInWithGoogle>(
        () => _i777.SignInWithGoogle(gh<_i1073.AuthRepository>()));
    gh.lazySingleton<_i879.SignInWithPhone>(
        () => _i879.SignInWithPhone(gh<_i1073.AuthRepository>()));
    gh.lazySingleton<_i858.ScanningRepository>(
        () => _i879.ScanningRepositoryImpl(
              gh<_i974.FirebaseFirestore>(),
              gh<_i457.FirebaseStorage>(),
            ));
    gh.factory<_i605.AuthBloc>(() => _i605.AuthBloc(
          gh<_i777.SignInWithGoogle>(),
          gh<_i879.SignInWithPhone>(),
          gh<_i93.AuthenticateWithBiometrics>(),
          gh<_i1073.AuthRepository>(),
        ));
    gh.lazySingleton<_i700.ApproveUser>(
        () => _i700.ApproveUser(gh<_i271.UserRepository>()));
    gh.lazySingleton<_i742.GetPendingUsers>(
        () => _i742.GetPendingUsers(gh<_i271.UserRepository>()));
    gh.lazySingleton<_i208.RejectUser>(
        () => _i208.RejectUser(gh<_i271.UserRepository>()));
    gh.lazySingleton<_i303.ScanImage>(
        () => _i303.ScanImage(gh<_i858.ScanningRepository>()));
    gh.factory<_i282.UserManagementBloc>(() => _i282.UserManagementBloc(
          gh<_i700.ApproveUser>(),
          gh<_i208.RejectUser>(),
          gh<_i742.GetPendingUsers>(),
        ));
    gh.factory<_i339.ScanningBloc>(
        () => _i339.ScanningBloc(gh<_i303.ScanImage>()));
    return this;
  }
}

class _$RegisterModule extends _i809.RegisterModule {}
