import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String adminId; // The user who created/owns this home
  final String? address;
  final String? photoUrl;
  final List<String> memberIds; // List of family member IDs
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const HomeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.adminId,
    this.address,
    this.photoUrl,
    required this.memberIds,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        adminId,
        address,
        photoUrl,
        memberIds,
        isActive,
        createdAt,
        updatedAt,
      ];
}