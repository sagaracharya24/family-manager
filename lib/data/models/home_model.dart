import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_entity.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel extends HomeEntity {
  const HomeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.adminId,
    super.address,
    super.photoUrl,
    required super.memberIds,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      adminId: json['adminId'] as String,
      address: json['address'] as String?,
      photoUrl: json['photoUrl'] as String?,
      memberIds: List<String>.from(json['memberIds'] ?? []),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? _parseDateTime(json['updatedAt']) : null,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.parse(value);
    if (value.runtimeType.toString().contains('Timestamp')) {
      return (value as dynamic).toDate();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'adminId': adminId,
      'address': address,
      'photoUrl': photoUrl,
      'memberIds': memberIds,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory HomeModel.fromEntity(HomeEntity entity) {
    return HomeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      adminId: entity.adminId,
      address: entity.address,
      photoUrl: entity.photoUrl,
      memberIds: entity.memberIds,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}