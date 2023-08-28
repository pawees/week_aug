import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:clean_architecture_my_project/data/repositories/promo_repository/models/promo_model.dart';

class PromoResponse extends Equatable {
  /// {@macro news_response}
  const PromoResponse({required this.promo,});


  @override
  static List<PromoModel> fromJson(List<dynamic> jsonString) {
    return jsonString
        .map((dynamic e) => PromoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  final List<PromoModel> promo;


  @override
  List<Object> get props => [promo,];
}
