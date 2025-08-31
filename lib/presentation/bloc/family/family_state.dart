import 'package:equatable/equatable.dart';

import '../../../domain/entities/family_member_entity.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object> get props => [];
}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyMembersLoaded extends FamilyState {
  final List<FamilyMemberEntity> members;
  
  const FamilyMembersLoaded(this.members);
  
  @override
  List<Object> get props => [members];
}

class FamilyError extends FamilyState {
  final String message;
  
  const FamilyError(this.message);
  
  @override
  List<Object> get props => [message];
}

class FamilyMemberAdded extends FamilyState {
  final FamilyMemberEntity member;
  
  const FamilyMemberAdded(this.member);
  
  @override
  List<Object> get props => [member];
}

class FamilyMemberUpdated extends FamilyState {
  final FamilyMemberEntity member;
  
  const FamilyMemberUpdated(this.member);
  
  @override
  List<Object> get props => [member];
}

class FamilyMemberRemoved extends FamilyState {
  final String memberId;
  
  const FamilyMemberRemoved(this.memberId);
  
  @override
  List<Object> get props => [memberId];
}