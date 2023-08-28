import '../repositories/news_repository/models/news_model.dart';
import '../repositories/promo_repository/models/promo_model.dart';

abstract class ApiInterface {
  getNews({int? count, int? offset,int? cityId});
  getPromo({int? count, int? offset,int? cityId});
}