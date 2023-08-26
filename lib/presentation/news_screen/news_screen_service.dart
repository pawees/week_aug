
//todo разобраться с контейнером полученных данных в дороничах есть,в новостных видел другое



//
// import '../../../data/repositories/news_screen_request/models/news_model.dart';
// import '../../../data/repositories/news_screen_request/news_repository.dart';
//
// // Сервис экрана с новостями
// class NewsScreenService{
//   final NewsScreenRequest newsScreenRequest = NewsScreenRequest();
//
//   // Список новостей
//   var _newsList = const <NewsModel>[];
//   List<NewsModel> get newsList => List.unmodifiable(_newsList);
//
//   // Парметр sendRequest нужен чтобы различать кто делает запрос
//   Future<void> getListNewsMethod(int count, bool sendRequest) async {
//     /*
//      Проверка перед запросм, если список новостей не пустой и
//      параметр sendRequest == true то не делаем запрос, а новости
//      на экране отображаются из уже существующего списка
//      */
//     if(_newsList.isNotEmpty && sendRequest == false) return;
//     final result = await newsScreenRequest.getNews(count: count);
//     _newsList = result;
//   }
//
// }

