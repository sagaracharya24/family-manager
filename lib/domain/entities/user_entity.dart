import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? familyId;
  final List<String> permissions;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.role,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.familyId,
    required this.permissions,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        phoneNumber,
        role,
        status,
        createdAt,
        updatedAt,
        familyId,
        permissions,
      ];
}