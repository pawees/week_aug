 import 'dart:io';

import 'package:clean_architecture_my_project/app/app_bloc_observer.dart';
import 'package:clean_architecture_my_project/services/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'my_app.dart';

 class MyHttpOverrides extends HttpOverrides {
   @override
   HttpClient createHttpClient(SecurityContext? context) {
     return super.createHttpClient(context)
       ..badCertificateCallback =
           (X509Certificate cert, String host, int port) => true;
   }
 }



 Future<void> main() async {
   ServiceLocator.initLocator();
   HttpOverrides.global = MyHttpOverrides();
   WidgetsFlutterBinding.ensureInitialized();
   Bloc.observer = AppBlocObserver();
   HydratedBloc.storage = await HydratedStorage.build(
     storageDirectory: await getTemporaryDirectory()
   );
   runApp(MyApp());
 }
