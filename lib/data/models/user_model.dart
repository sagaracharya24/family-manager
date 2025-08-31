import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.phoneNumber,
    required super.role,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.familyId,
    required super.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle Firestore Timestamp conversion
    final createdAtValue = json['createdAt'];
    final updatedAtValue = json['updatedAt'];
    
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.parse(value);
      if (value.runtimeType.toString().contains('Timestamp')) {
        return (value as dynamic).toDate();
      }
      return DateTime.now();
    }
    
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: parseDateTime(createdAtValue),
      updatedAt: updatedAtValue != null ? parseDateTime(updatedAtValue) : null,
      familyId: json['familyId'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      familyId: entity.familyId,
      permissions: entity.permissions,
    );
  }
}