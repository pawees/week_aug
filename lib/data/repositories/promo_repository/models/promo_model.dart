import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promo_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PromoModel extends Equatable{
  final String? title;
  final String? startDate;
  final String? endDate;
  final String? miniPhoto;

  const PromoModel({
    this.title,
    this.startDate,
    this.endDate,
    this.miniPhoto,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => _$PromoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromoModelToJson(this);

  @override
  List<Object?> get props => [title, startDate, endDate, miniPhoto];

}
