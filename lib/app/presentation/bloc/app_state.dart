part of 'app_bloc.dart';

enum AppStatus {
  onboardingRequired(),
  authenticated(),
  unauthenticated();

  bool get isLoggedIn => this == AppStatus.authenticated;

  bool get isOnboardingRequired => this == AppStatus.onboardingRequired;
}

class AppState extends Equatable {
  const AppState({
    required this.status,
  });

  final AppStatus status;



  const AppState.authenticated()
      : this(
          status: AppStatus.authenticated,
        );

  const AppState.onboardingRequired()
      : this(
          status: AppStatus.onboardingRequired,
        );
  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  @override
  List<Object?> get props => [
        status,
      ];

  AppState copyWith({
    AppStatus? status,
    bool? showLoginOverlay,
  }) {
    return AppState(
      status: status ?? this.status,
    );
  }
}
