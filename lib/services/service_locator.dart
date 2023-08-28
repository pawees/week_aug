import 'package:clean_architecture_my_project/data/api/mock/mockup_client.dart';
import 'package:http/http.dart' as http;

import 'package:clean_architecture_my_project/data/api/http/app_api_client.dart';
import 'package:clean_architecture_my_project/data/repositories/user_repositiry/user_repository.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/news_repository/news_repository.dart';
import '../data/repositories/promo_repository/promo_repository.dart';

GetIt instanceStorage = GetIt.instance;

class ServiceLocator {
  static void initLocator() {
    ///api
    Future<String?> _tokenProvider() {
      return Future.delayed(
        const Duration(seconds: 2),
        () => '',
      );
    }

    instanceStorage.registerSingleton<AppApiClient>(
      AppApiClient.doctorLight(
          httpClient: http.Client(), tokenProvider: _tokenProvider()),
    );

    ///repositories
    instanceStorage.registerSingleton<UserRepository>(UserRepository(),
        signalsReady: true);
    instanceStorage.registerSingleton<NewsRepository>(
        NewsRepository(apiClient: instanceStorage<AppApiClient>()),
        signalsReady: true);
    instanceStorage.registerSingleton<PromoRepository>(
        PromoRepository(apiClient: instanceStorage<AppApiClient>()),
        signalsReady: true);
  }

  static void initLocatorMock() {
    ///api
    Future<String?> _tokenProvider() {
      return Future.delayed(
        const Duration(seconds: 2),
            () => '',
      );
    }

    instanceStorage.registerSingleton<MockupClient>(
      MockupClient());

    ///repositories
    instanceStorage.registerSingleton<UserRepository>(UserRepository(),
        signalsReady: true);
    instanceStorage.registerSingleton<NewsRepository>(
        NewsRepository(apiClient: instanceStorage<MockupClient>()),
        signalsReady: true);
    instanceStorage.registerSingleton<PromoRepository>(
        PromoRepository(apiClient: instanceStorage<MockupClient>()),
        signalsReady: true);
  }

}
