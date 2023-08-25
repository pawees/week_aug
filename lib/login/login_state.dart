part of 'login_bloc.dart';

enum SubmissionStatus {

  initial,

  inProgress,

  success,

  failure,

  canceled

}

class LoginState extends Equatable {
  const LoginState({
    this.status = SubmissionStatus.initial,
  });

  final SubmissionStatus status;

  @override
  List<Object> get props => [status,];

  LoginState copyWith({
    SubmissionStatus? status,
  }) {
    return LoginState(
      status: status ?? this.status,
    );
  }
}
