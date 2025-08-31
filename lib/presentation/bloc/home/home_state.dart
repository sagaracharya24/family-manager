import 'package:equatable/equatable.dart';

import '../../../domain/entities/home_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomesLoaded extends HomeState {
  final List<HomeEntity> homes;
  final HomeEntity? selectedHome;
  
  const HomesLoaded(this.homes, {this.selectedHome});
  
  @override
  List<Object?> get props => [homes, selectedHome];
}

class HomeSelected extends HomeState {
  final HomeEntity home;
  
  const HomeSelected(this.home);
  
  @override
  List<Object> get props => [home];
}

class HomeCreated extends HomeState {
  final HomeEntity home;
  
  const HomeCreated(this.home);
  
  @override
  List<Object> get props => [home];
}

class HomeUpdated extends HomeState {
  final HomeEntity home;
  
  const HomeUpdated(this.home);
  
  @override
  List<Object> get props => [home];
}

class HomeDeleted extends HomeState {
  final String homeId;
  
  const HomeDeleted(this.homeId);
  
  @override
  List<Object> get props => [homeId];
}

class HomeError extends HomeState {
  final String message;
  
  const HomeError(this.message);
  
  @override
  List<Object> get props => [message];
}