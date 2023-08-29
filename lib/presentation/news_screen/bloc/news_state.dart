part of 'news_bloc.dart';

//единый стэйт хранит в себе все сохраненные данные
//точнее данные с инита так что все можно будет найти тут в
//стэйте

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
  const NewsState({required this.status, this.listNews = const []});

  const NewsState.initial()
      : this(
          status: NewsStatus.initial,
        );

  final NewsStatus status;
  final List<NewsModel> listNews;

  @override
  List<Object?> get props => [status, listNews];

  NewsState copyWith({
    NewsStatus? status,
    List<NewsModel>? listNews,
  }) {
    return NewsState(
      status: status ?? this.status,
      listNews: listNews ?? this.listNews,
    );
  }
}
