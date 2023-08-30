//todo add api impl and storage
//todo написать справку о репозитории всю информацию

import 'dart:async';


import '../../../app/presentation/bloc/app_bloc.dart';
///Характеристика репозитория - имеют методы запросы
/// связаны с внешними сервисами. нужен только чтобы извлекать специфичные модели,
/// (например только модели новостей,модели акций в другом репозитории).
/// Одним и тем же репозиторием могут пользоваться разные сервисы(в нашем случае блоки)
/// репозиторию неважно кто им пользуется получается блоку можно подставить любой вариант для получения
/// данных

class UserRepository {

  ///создаю стрим,который покажет если статус пользователя изменится
  final _userUpdateStreamController = StreamController<AppStatus>.broadcast();
  Stream<AppStatus> get user =>
      _userUpdateStreamController.stream.asBroadcastStream();

  ///обращение к какому-то api аутентификации, в примере ее нет так что просто
  ///закидываем событие в стрим нового статуса
  Future<void> logInWithToggle() async {
      _userUpdateStreamController.add(AppStatus.authenticated);

  }

  ///закидываем событие в стрим нового статуса
  Future<void> logOut() async {

      _userUpdateStreamController.add(AppStatus.unauthenticated);

  }

}








