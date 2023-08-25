import 'package:clean_architecture_my_project/data/repositories/user_repositiry/user_repository.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/news_repository/news_repository.dart';
import '../data/repositories/promo_repository/promo_repository.dart';

GetIt instanceStorage = GetIt.instance;

class ServiceLocator{
  static void initLocator() {
    ///api
    //todo написать apiClient хороший
    //точнее переделать тот который есть

    ///repositories
    instanceStorage.registerSingleton<UserRepository>(UserRepository(),
        signalsReady: true);
    instanceStorage.registerSingleton<NewsRepository>(NewsRepository(),
        signalsReady: true);
    instanceStorage.registerSingleton<PromoRepository>(PromoRepository(),
        signalsReady: true);
  }
}