import 'package:equatable/equatable.dart';

class FamilyMemberEntity extends Equatable {
  final String id;
  final String homeId; // Changed from familyId to homeId
  final String userId;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final String role;
  final List<String> permissions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FamilyMemberEntity({
    required this.id,
    required this.homeId,
    required this.userId,
    required this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        homeId,
        userId,
        name,
        email,
        phoneNumber,
        photoUrl,
        role,
        permissions,
        isActive,
        createdAt,
        updatedAt,
      ];
}