import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:clean_architecture_my_project/data/repositories/news_repository/models/news_model.dart';

class NewsResponse extends Equatable {
  /// {@macro news_response}
  const NewsResponse({required this.news,});


  @override
  static List<NewsModel> fromJson(List<dynamic> jsonString) {
    return jsonString
        .map((dynamic e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  final List<NewsModel> news;


  @override
  List<Object> get props => [news,];
}
