import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/family_member_entity.dart';

part 'family_member_model.g.dart';

@JsonSerializable()
class FamilyMemberModel extends FamilyMemberEntity {
  const FamilyMemberModel({
    required super.id,
    required super.homeId,
    required super.userId,
    required super.name,
    super.email,
    super.phoneNumber,
    super.photoUrl,
    required super.role,
    required super.permissions,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) => _$FamilyMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyMemberModelToJson(this);

  factory FamilyMemberModel.fromEntity(FamilyMemberEntity entity) {
    return FamilyMemberModel(
      id: entity.id,
      homeId: entity.homeId,
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      photoUrl: entity.photoUrl,
      role: entity.role,
      permissions: entity.permissions,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}