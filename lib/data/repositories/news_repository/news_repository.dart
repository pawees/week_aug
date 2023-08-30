import '../../api/api_interface.dart';
import 'models/news_model.dart';
import 'package:equatable/equatable.dart';

//todo зачем я должен определять эти кастомные ошибки

abstract class NewsFailure with EquatableMixin implements Exception {
  const NewsFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class NewsLimitFailure extends NewsFailure {
  const NewsLimitFailure(super.error);
}

class NewsRepository {
  NewsRepository({
    required ApiInterface apiClient,
  }) : _apiClient = apiClient;

  final ApiInterface _apiClient;

  int countLimitedNews = 3;
  bool isLimit = true;

  set newsLimit(bool limit) => isLimit = !isLimit;

  _dicreaseCountLimited(int step) {
    countLimitedNews -= step;
  }

  Future<void> requestNews() async {
    if (isLimit && countLimitedNews <= 0) {
      Error.throwWithStackTrace(
          NewsLimitFailure('Not Authorize'), StackTrace.current);
    }
  }

  Future<List<NewsModel>> getNews(
      {required int count, required int step}) async {
    _dicreaseCountLimited(step);
    final result = _apiClient.getNews(count: count, offset: 0, cityId: 0);
    return result;
  }
}
