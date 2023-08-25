import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/user_repositiry/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class AuthenticationException implements Exception {
  /// {@macro authentication_exception}
  const AuthenticationException(this.error);

  /// The error which was caught.
  final Object error;
}


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginToggleSubmitted>(_onToggleChoose);
  }

  final UserRepository _userRepository;

  void _onToggleChoose(LoginToggleSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: SubmissionStatus.inProgress));
    await Future.delayed(const Duration(milliseconds: 1500));
    try {
      await _userRepository.logInWithToggle();
      emit(state.copyWith(status: SubmissionStatus.success));
    } on AuthenticationException {
      emit(state.copyWith(status: SubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

}
