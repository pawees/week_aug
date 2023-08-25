import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/user_repositiry/user_repository.dart';
import '../../dynamic_theme/theme_bloc.dart';
import '../../login/login_bloc.dart';
import '../../presentation/navigation_bar/navigation_bar.dart';
import '../../services/service_locator.dart';
import '../bloc/app_bloc.dart';
import '../routes/src/routes.dart';



class AppPage extends StatelessWidget {
  const AppPage({required this.viewBottom,required this.child, Key? key})
      : super(key: key);

  final BottomNavigationView viewBottom;
  final Widget child;

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
      ],
      child: MainPage(child: child, bottomNavigation: viewBottom,),
    );
  }
}



//todo переделать под блок лисенер, либо передавать навигатор
class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.child, required this.bottomNavigation});

  final Widget child;
  final BottomNavigationView bottomNavigation;
  static get hideBottomBar => SizedBox();


  @override
  Widget build(BuildContext context) {
    switch (bottomNavigation) {
      case BottomNavigationView.hide:
        return Scaffold(
          body: child,
          bottomNavigationBar: MainPage.hideBottomBar ,
        );
      case BottomNavigationView.hide:
        return Scaffold(
          body: child,
        );
      default:
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigation(),
        );
    }
  }
}

