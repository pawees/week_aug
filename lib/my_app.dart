import 'package:clean_architecture_my_project/resources/app_theme.dart';
import 'package:flutter/material.dart';

import 'app/routes/src/routes.dart';



class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      routerConfig: AppRouter.router,
    );
  }
}