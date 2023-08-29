import 'package:flutter/material.dart';
import '../../presentation/navigation_bar/navigation_bar.dart';
import '../routes/src/routes.dart';



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
        );
      case BottomNavigationView.show:
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigation(),
        );
    }
  }
}

