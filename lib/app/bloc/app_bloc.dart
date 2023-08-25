import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/user_repositiry/user_repository.dart';


part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
        super(AppState.unauthenticated())//todo написать тут проверку статуса
  {
    on<AppOpened>(_onAppOpened);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppUserChanged>(_onCatchUserChanged);
    on<AppOnboardingCompleted>(_onOnboardingCompleted);

    _userSubscription = _userRepository.user.listen(_userChanged);
  }

  late StreamSubscription<AppStatus> _userSubscription;
  final UserRepository _userRepository;

  void _onOnboardingCompleted(
    AppOnboardingCompleted event,
    Emitter<AppState> emit,
  ) {
    if (state.status == AppStatus.onboardingRequired) {
      //проверить состояние пользователя
      //в зависимости от этого эмиттить
      return emit(const AppState.unauthenticated());

    }
  }
  void _userChanged(AppStatus update) => add(AppUserChanged(update));

  void _onCatchUserChanged(AppUserChanged event, Emitter<AppState> emit) {

    final user = event.update;

    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return user == AppStatus.unauthenticated ?
          emit(state.copyWith(status: AppStatus.unauthenticated))
        : emit(state.copyWith(status: AppStatus.authenticated));
        //тут проверка статуса пользователя
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    //отключить доставку уведомлений,удалить акцес токен и тд.
    //почистить всё
    _userRepository.logOut();
  }


  Future<void> _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    //присвоить какой-либо статус после открытия приложения
    //акцию можно
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
