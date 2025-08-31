import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/home/create_home.dart' as create_home_usecase;
import '../../../domain/usecases/home/get_user_homes.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUserHomes _getUserHomes;
  final create_home_usecase.CreateHome _createHome;

  HomeBloc(
    this._getUserHomes,
    this._createHome,
  ) : super(HomeInitial()) {
    on<LoadUserHomes>(_onLoadUserHomes);
    on<CreateHome>(_onCreateHome);
    on<SelectHome>(_onSelectHome);
    on<UpdateHome>(_onUpdateHome);
    on<DeleteHome>(_onDeleteHome);
  }

  Future<void> _onLoadUserHomes(
    LoadUserHomes event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    
    final result = await _getUserHomes(GetUserHomesParams(adminId: event.adminId));
    
    result.fold(
      (failure) => emit(HomeError(failure.toString())),
      (homes) => emit(HomesLoaded(homes)),
    );
  }

  Future<void> _onCreateHome(
    CreateHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    
    final homeId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final result = await _createHome(create_home_usecase.CreateHomeParams(
      id: homeId,
      name: event.name,
      description: event.description,
      adminId: event.adminId,
      address: event.address,
      photoUrl: event.photoUrl,
    ));
    
    result.fold(
      (failure) => emit(HomeError(failure.toString())),
      (home) => emit(HomeCreated(home)),
    );
  }

  Future<void> _onSelectHome(
    SelectHome event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomesLoaded) {
      final currentState = state as HomesLoaded;
      final selectedHome = currentState.homes.firstWhere((home) => home.id == event.homeId);
      emit(HomesLoaded(currentState.homes, selectedHome: selectedHome));
    }
  }

  Future<void> _onUpdateHome(
    UpdateHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    // TODO: Implement update home use case
    emit(const HomeError('Update home not implemented yet'));
  }

  Future<void> _onDeleteHome(
    DeleteHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    // TODO: Implement delete home use case
    emit(const HomeError('Delete home not implemented yet'));
  }
}