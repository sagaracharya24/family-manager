import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final LocalAuthentication _localAuth;

  AuthRepositoryImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._firestore,
  ) : _localAuth = LocalAuthentication();

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return const Left(AuthenticationFailure('Google sign in was cancelled'));
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return const Left(AuthenticationFailure('Failed to sign in with Google'));
      }

      // Check if this is the first user (bootstrap super admin)
      final usersQuery = await _firestore.collection(AppConstants.usersCollection).limit(1).get();
      final isFirstUser = usersQuery.docs.isEmpty;

      final userEntity = UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        role: isFirstUser ? AppConstants.roleSuperAdmin : AppConstants.roleFamilyMember,
        status: isFirstUser ? AppConstants.userStatusApproved : AppConstants.userStatusPending,
        createdAt: DateTime.now(),
        permissions: isFirstUser ? [
          AppConstants.permissionCreateFamily,
          AppConstants.permissionManageMembers,
          AppConstants.permissionScanImages,
          AppConstants.permissionViewReports,
          AppConstants.permissionExportData,
        ] : [],
      );

      // Save user to Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userEntity.toJson(), SetOptions(merge: true));

      return Right(userEntity);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  String? _verificationId;
  
  @override
  Future<Either<Failure, UserEntity>> signInWithPhoneNumber(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (happens on some devices)
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw AuthenticationFailure('Phone verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
      
      // Return a pending state - actual sign in happens in verifyPhoneNumber
      return Left(AuthenticationFailure('VERIFICATION_CODE_SENT'));
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyPhoneNumber(String verificationCode) async {
    try {
      if (_verificationId == null) {
        return Left(AuthenticationFailure('No verification ID found. Please request code again.'));
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: verificationCode,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return Left(AuthenticationFailure('Failed to sign in with phone number'));
      }

      // Check if this is the first user (bootstrap super admin)
      final usersQuery = await _firestore.collection(AppConstants.usersCollection).limit(1).get();
      final isFirstUser = usersQuery.docs.isEmpty;

      final userEntity = UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'Phone User',
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        role: isFirstUser ? AppConstants.roleSuperAdmin : AppConstants.roleFamilyMember,
        status: isFirstUser ? AppConstants.userStatusApproved : AppConstants.userStatusPending,
        createdAt: DateTime.now(),
        permissions: isFirstUser ? [
          AppConstants.permissionCreateFamily,
          AppConstants.permissionManageMembers,
          AppConstants.permissionScanImages,
          AppConstants.permissionViewReports,
          AppConstants.permissionExportData,
        ] : [],
      );

      // Save user to Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userEntity.toJson(), SetOptions(merge: true));

      return Right(userEntity);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometrics() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        return const Left(AuthenticationFailure('Biometrics not available'));
      }

      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return Right(isAuthenticated);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Right(null);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return const Right(null);

      // Fetch user data from Firestore
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final userEntity = UserModel.fromJson(userData);
        return Right(userEntity);
      }

      // Fallback for users not in Firestore yet
      final userEntity = UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        role: AppConstants.roleFamilyMember,
        status: AppConstants.userStatusPending,
        createdAt: DateTime.now(),
        permissions: [],
      );

      return Right(userEntity);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        role: 'family_member',
        status: 'approved',
        createdAt: DateTime.now(),
        permissions: [],
      );
    });
  }
}