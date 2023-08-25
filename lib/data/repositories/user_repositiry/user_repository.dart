//todo add api impl and storage
//todo написать справку о репозитории всю информацию

import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../app/bloc/app_bloc.dart';

class UserRepository {

  final _userUpdateStreamController = StreamController<AppStatus>.broadcast();
  Stream<AppStatus> get user =>
      _userUpdateStreamController.stream.asBroadcastStream();

  Future<void> logInWithToggle() async {
      _userUpdateStreamController.add(AppStatus.authenticated);

  }

  Future<void> logOut() async {

      _userUpdateStreamController.add(AppStatus.unauthenticated);

  }

}


abstract class UserUpdate extends Equatable {
  const UserUpdate();
}


class UserAuthenticated extends UserUpdate {
  const UserAuthenticated() : super();

  @override
  List<Object?> get props => throw UnimplementedError();


}


class UserIsAnonymous extends UserUpdate {
  const UserIsAnonymous() : super();

  @override
  List<Object?> get props => throw UnimplementedError();


}