import 'package:equatable/equatable.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object> get props => [];
}

class LoadFamilyMembers extends FamilyEvent {
  final String familyId;
  
  const LoadFamilyMembers({required this.familyId});
  
  @override
  List<Object> get props => [familyId];
}

class AddFamilyMember extends FamilyEvent {
  final String name;
  final String email;
  final String role;
  final String familyId;
  
  const AddFamilyMember({
    required this.name,
    required this.email,
    required this.role,
    required this.familyId,
  });
  
  @override
  List<Object> get props => [name, email, role, familyId];
}

class UpdateFamilyMember extends FamilyEvent {
  final String memberId;
  final String name;
  final String email;
  final String role;
  
  const UpdateFamilyMember({
    required this.memberId,
    required this.name,
    required this.email,
    required this.role,
  });
  
  @override
  List<Object> get props => [memberId, name, email, role];
}

class RemoveFamilyMember extends FamilyEvent {
  final String memberId;
  
  const RemoveFamilyMember({required this.memberId});
  
  @override
  List<Object> get props => [memberId];
}

class UpdatePermissions extends FamilyEvent {
  final String memberId;
  final List<String> permissions;
  
  const UpdatePermissions({
    required this.memberId,
    required this.permissions,
  });
  
  @override
  List<Object> get props => [memberId, permissions];
}