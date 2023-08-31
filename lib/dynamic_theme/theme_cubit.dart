import 'dart:async';

import 'package:clean_architecture_my_project/resources/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../app/presentation/bloc/app_bloc.dart';
import '../data/repositories/user_repositiry/user_repository.dart';

///Кубит упрощенная версия блока работает напрямую с состояниями без использования событий
///сценарий: вначале без гидроблока
///потом добавить его и узнать результат

class ThemeCubit extends HydratedCubit<ThemeData> {
  ThemeCubit({required UserRepository userRepository}) : _userRepository= userRepository,
        super(defaultTheme) {

    ///подписчик, который слушает изменения в стриме
    _userSubscription = _userRepository.user.listen(_onUpdateTheme);

  }

  static final defaultTheme = MyAppTheme.themeDefault().use();

  final UserRepository _userRepository;
  late StreamSubscription<AppStatus> _userSubscription;

  void _onUpdateTheme(AppStatus update) {

    if (update == AppStatus.unauthenticated ) emit(MyAppTheme.themeDefault().use());
    if (update == AppStatus.authenticated) emit(MyAppTheme.themePremium().use());
  }

  @override
  ThemeData fromJson(Map<String, dynamic> json) {
    if(json['value'] == 1){
      return MyAppTheme.themeDefault().use();
    } else{
      return MyAppTheme.themePremium().use();
    }
  }

  @override
  Map<String, int> toJson(ThemeData state) {
    if (state == MyAppTheme.themeDefault().use()){
      return {'value': 1 };
    } else {
      return {'value': 2};
    }
  }

}
