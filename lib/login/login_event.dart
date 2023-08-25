part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}


class LoginToggleSubmitted extends LoginEvent {
  const LoginToggleSubmitted({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}
