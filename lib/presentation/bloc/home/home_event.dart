import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadUserHomes extends HomeEvent {
  final String adminId;
  
  const LoadUserHomes({required this.adminId});
  
  @override
  List<Object> get props => [adminId];
}

class CreateHome extends HomeEvent {
  final String name;
  final String description;
  final String adminId;
  final String? address;
  final String? photoUrl;
  
  const CreateHome({
    required this.name,
    required this.description,
    required this.adminId,
    this.address,
    this.photoUrl,
  });
  
  @override
  List<Object> get props => [name, description, adminId];
}

class SelectHome extends HomeEvent {
  final String homeId;
  
  const SelectHome({required this.homeId});
  
  @override
  List<Object> get props => [homeId];
}

class UpdateHome extends HomeEvent {
  final String homeId;
  final String name;
  final String description;
  final String? address;
  final String? photoUrl;
  
  const UpdateHome({
    required this.homeId,
    required this.name,
    required this.description,
    this.address,
    this.photoUrl,
  });
  
  @override
  List<Object> get props => [homeId, name, description];
}

class DeleteHome extends HomeEvent {
  final String homeId;
  
  const DeleteHome({required this.homeId});
  
  @override
  List<Object> get props => [homeId];
}