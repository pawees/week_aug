import '../../api/api_interface.dart';
import '../../method_constants.dart';
import '../../api/http/app_api_client.dart';
import 'models/news_model.dart';

//todo зачем я должен определять эти кастомные ошибки

abstract class NewsFailure implements Exception {
  /// {@macro in_app_purchase_failure}
  const NewsFailure(this.message);

  /// The error which was caught.

  final String message;

}

class NewsLimitFailure extends NewsFailure {
  const NewsLimitFailure(super.message);
}


class NewsRepository {

   NewsRepository({
    required ApiInterface apiClient,
  }) : _apiClient = apiClient;


   final ApiInterface _apiClient;

   int countLimitedNews = 6;
  bool isLimit = true;

set newsLimit(bool limit) => isLimit = !isLimit;


  countLimited() {
    countLimitedNews -= 3;
  }



  Future<List<NewsModel>> getNews({
    required int count,
    required int step
  }) async {
    final Map<String, dynamic> params = {
      "offset": 0,
      "count": count,
      "city_id": ''
    };
    if (isLimit) {
      countLimitedNews -= step;
      if(countLimitedNews <= 0 ) {
        Error.throwWithStackTrace(NewsLimitFailure('Authorize that give move news...'), StackTrace.current);
      }

    }
    /*
    Объявление функции parseJson, принимающей на вход
    динамический объект json и возвращающей список объектов типа NewsModel
     */
    List<NewsModel> parseJson(dynamic json) {
      // приведение объекта json к типу Map<String, dynamic> и сохранение его в переменную jsonMap
      final jsonMap = json as Map<String, dynamic>;
      // создание пустого списка объектов типа NewsModel и сохранение его в переменную listObject
      final listObject = <NewsModel>[];
      // проверка, содержит ли объект jsonMap свойство "result"
      if (jsonMap.containsKey('result')) {
        /*
        извлечение значения свойства "result" и преобразование его в
        список объектов типа NewsModel с помощью метода from() класса List
         */
        final resultJson = List<NewsModel>.from((jsonMap["result"] as List)
            /*
            // преобразование каждого элемента списка из типа Map<String, dynamic> в
            объект типа NewsModel с помощью метода map()
             */
            .map((e) => NewsModel.fromJson(e)));
        return resultJson; // возвращение списка объектов типа NewsModel
      } else {
        return listObject; // возвращение пустого списка объектов типа NewsModel
      }
    }

    final result = _apiClient.getNews(
        count: count, offset: 0, cityId: 0);
    return result;
  }

}
