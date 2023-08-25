import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_architecture_my_project/app/routes/routes.dart';

import '../../../presentation/pages/promo_screen/promo_screen.dart';
import '../../../presentation/pages/test_screen_three.dart';
import '../../presentation/app.dart';

enum BottomNavigationView { hide, show }

abstract class ExceptionPath {
  ///in this case bottomNavBar is not rendered
  static List<String> exceptions = [
    '/card/theme',
    '/news/theme',
    '/news/details'
  ];
}

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppPath.newsScreenPath,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            Wrapper(state: state.location, child: child),
        routes: [
          GoRoute(
            name: AppRoutes.newsRoute,
            path: AppPath.newsScreenPath,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NewsScreenPage(),
            ),
            routes: [
              GoRoute(
                name: AppRoutes.testScreenOneRoute,
                path: AppPath.testScreenOnePath,
                pageBuilder: (context, state) => const CupertinoPage(
                  child: TestScreenOneWidget(),
                ),
              ),
            ],
          ),
          GoRoute(
            name: AppRoutes.promoRoute,
            path: AppPath.promoScreenPath,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PromoScreenPage(),
            ),
            routes: [
              GoRoute(
                  name: AppRoutes.testScreenTwoRoute,
                  path: AppPath.testScreenTwoPath,
                  pageBuilder: (context, state) => const CupertinoPage(
                        child: TestScreenTwoWidget(),
                      ),
                  routes: [
                    GoRoute(
                      name: AppRoutes.testScreenThreeRoute,
                      path: AppPath.testScreenThreePath,
                      pageBuilder: (context, state) => const CupertinoPage(
                        child: TestScreenThreeWidget(),
                      ),
                    ),
                  ]),
            ],
          ),
        ],
      )
    ],
  );
}


class Wrapper extends StatelessWidget {
  const Wrapper({required this.state, required this.child, Key? key})
      : super(key: key);
  final String? state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (ExceptionPath.exceptions.contains(state)) {
      return AppPage(
          child: child, viewBottom: BottomNavigationView.hide);
    } else {
      return AppPage(
          child: child, viewBottom: BottomNavigationView.show);
    }
  }
}
