import 'package:clean_architecture_my_project/presentation/news_screen/bloc/news_bloc.dart';
import 'package:clean_architecture_my_project/presentation/pages/promo_screen/bloc/promo_bloc.dart';
import 'package:clean_architecture_my_project/resources/app_theme.dart';
import 'package:clean_architecture_my_project/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/bloc/app_bloc.dart';
import 'app/routes/src/routes.dart';
import 'data/repositories/news_repository/news_repository.dart';
import 'data/repositories/promo_repository/promo_repository.dart';
import 'data/repositories/user_repositiry/user_repository.dart';
import 'dynamic_theme/theme_bloc.dart';
import 'login/login_bloc.dart';

//todo есть смысл обернуть материал апп основными блоками
//бонусом можно будет менять тему(темная-светлая)
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppBloc(userRepository: instanceStorage<UserRepository>(),),
        ),
        BlocProvider(
          create: (_) => ThemeBloc(), //todo сделать прослушиватель изменение пользователя,поменять цвет например.
        ),
        BlocProvider(
          create: (_) => LoginBloc(userRepository: instanceStorage<UserRepository>(),), //todo место,отвечающее за все возможные аутентификации
        ),
        BlocProvider(create: (_) => NewsBloc(
            newsRepository: instanceStorage<NewsRepository>(),
            userRepository: instanceStorage<UserRepository>())
          ..add(const GetListNewsEvent(false, 0 )),),
         BlocProvider<PromoBloc>(
    create: (context) => PromoBloc(promoRepository: instanceStorage<PromoRepository>())..add(const GetListPromoEvent(3, false)),)

      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
