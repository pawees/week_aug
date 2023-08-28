import 'dart:async';
import 'package:clean_architecture_my_project/data/api/api_interface.dart';
import 'package:clean_architecture_my_project/data/api/mock/json_sample_data.dart';
import 'package:clean_architecture_my_project/data/api/models/promo_responce.dart';
import 'package:clean_architecture_my_project/data/api/models/news_response.dart';
import 'package:clean_architecture_my_project/data/repositories/news_repository/models/news_model.dart';
import 'package:clean_architecture_my_project/data/repositories/promo_repository/models/promo_model.dart';

class MockupClient implements ApiInterface {
  @override
  List<NewsModel> getNews({
    int? count,
    int? offset,
    int? cityId,
  }) {
    List<dynamic> data = JsonSampleData.get_news();

    return NewsResponse.fromJson(data);
  }

  @override
  Future<List<PromoModel>> getPromo({
    int? count,
    int? offset,
    int? cityId,
  }) async {
    List<dynamic> data = JsonSampleData.get_promo();

    return PromoResponse.fromJson(data);
  }
}
