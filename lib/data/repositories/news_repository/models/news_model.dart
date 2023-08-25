
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NewsModel extends Equatable{
  final String? title;
  final String? startDate;
  final String? miniPhoto;

  const NewsModel({
     this.title,
     this.startDate,
     this.miniPhoto,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => _$NewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsModelToJson(this);

  @override
  List<Object?> get props => [title, startDate, miniPhoto];



}