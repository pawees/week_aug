part of 'news_bloc.dart';


///энам в котором есть значение
enum NewsStatus {
  initial(),
  loaded(),
  loading(),
  failed(message: 'Network issue'),
  forbidden(message: 'Authorize please');

  const NewsStatus({this.message = ''});

  final String message;
}

class NewsState extends Equatable {
  const NewsState({required this.status, this.listNews = const [], this.offset = 0,});

  const NewsState.initial()
      : this(
          status: NewsStatus.initial,
        );

  final NewsStatus status;
  final List<NewsModel> listNews;
  final double offset;

  @override
  List<Object?> get props => [status, listNews,offset];
  ///конструктор класса который заменяет только нужный параметр поэтому при смене стейта
  ///старые данные продолжают храниться и ими можно пользоваться
  NewsState copyWith({
    NewsStatus? status,
    List<NewsModel>? listNews,
    double? offset,
  }) {
    return NewsState(
      status: status ?? this.status,
      listNews: listNews ?? this.listNews,
      offset: offset ?? this.offset,
    );
  }
}
