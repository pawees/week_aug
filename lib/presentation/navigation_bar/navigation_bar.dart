import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/bloc/app_bloc.dart';
import '../../resources/app_routes.dart';
import '../../resources/app_strings.dart';
import '../../resources/app_values.dart';
import 'dart:math' as math;

int global_index = 0;

void _onItemTapped(int index, BuildContext context) {
  global_index = index;
  switch (index) {
    case 0:
      context.goNamed(AppRoutes.newsRoute);
      break;
    case 1:
      context.goNamed(AppRoutes.promoRoute);
      break;
    case 2:
      context.goNamed(AppRoutes.testScreenOneRoute);
      break;
    case 3:
      context.goNamed(AppRoutes.testScreenTwoRoute);
      break;
  }
}


class FadeTransitionExample extends StatefulWidget {
  const FadeTransitionExample({
    required this.child,
    super.key});

  final AppStatus child;

  @override
  State<FadeTransitionExample> createState() => _FadeTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _FadeTransitionExampleState extends State<FadeTransitionExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _controller.reset(); // stops the animation if in progress
      _controller.forward();
    });
    return ColoredBox(
      color: Colors.white,
      child: FadeTransition(
        opacity: _animation,
        child: widget.child == AppStatus.unauthenticated ? BottomNavigationUnauthenticated() :
        BottomNavigationAuthenticated(),
      ),
    );
  }
}




class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state.status == AppStatus.authenticated) {
          return FadeTransitionExample(child: AppStatus.authenticated,);
        } else {
          return FadeTransitionExample(child: AppStatus.unauthenticated,);
        }
      },
    );
  }
}




class BottomNavigationAuthenticated extends StatelessWidget {
  const BottomNavigationAuthenticated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // backgroundColor: Colors.blueGrey,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          label: NavigationBarStrings.news,
          icon: Icon(
            Icons.mark_unread_chat_alt_outlined,
            size: AppSize.s20,
          ),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.blue,
          label: NavigationBarStrings.promo,
          icon: Icon(
            Icons.paid_rounded,
            size: AppSize.s20,
          ),
        ),
        BottomNavigationBarItem(
          label: NavigationBarStrings.empty,
          icon: Icon(
            Icons.add_circle_outline,
            size: AppSize.s20,
          ),
        ),
      ],
      currentIndex: global_index,
      onTap: (index) => _onItemTapped(index, context),
    );
  }
}

class BottomNavigationUnauthenticated extends StatelessWidget {
  const BottomNavigationUnauthenticated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: NavigationBarStrings.news,
          icon: Icon(
            Icons.mark_unread_chat_alt_outlined,
            size: AppSize.s20,
          ),
        ),
        BottomNavigationBarItem(
          label: NavigationBarStrings.empty,
          icon: Icon(
            Icons.add_circle_outline,
            size: AppSize.s20,
          ),
        ),
      ],
      currentIndex: global_index,
      onTap: (index) => _onItemTapped(index, context),
    );
  }
}

class BottomNavigationSuperUser extends StatelessWidget {
  const BottomNavigationSuperUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: NavigationBarStrings.news,
          icon: Icon(
            Icons.mark_unread_chat_alt_outlined,
            size: AppSize.s20,
          ),
        ),
        BottomNavigationBarItem(
          label: NavigationBarStrings.promo,
          icon: Icon(
            Icons.paid_rounded,
            size: AppSize.s20,
          ),
        ),
        BottomNavigationBarItem(
          label: NavigationBarStrings.empty,
          icon: Icon(
            Icons.add_circle_outline,
            size: AppSize.s20,
          ),
        ),
        BottomNavigationBarItem(
          label: NavigationBarStrings.empty,
          icon: Icon(
            Icons.add_circle_outline,
            size: AppSize.s20,
          ),
        ),
      ],
      currentIndex: global_index,
      onTap: (index) => _onItemTapped(index, context),
    );
  }
}
