part of 'news_bloc.dart';

@immutable
abstract class NewsEvent extends Equatable{
  const NewsEvent();
  @override
  List<Object?> get props => [];
}

class GetListNewsEvent extends NewsEvent{

final bool sendRequest;

  const GetListNewsEvent(this.sendRequest);

@override
List<Object?> get props => [sendRequest];

}
