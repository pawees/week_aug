part of 'news_bloc.dart';

//единый стэйт хранит в себе все сохраненные данные
//точнее данные с инита так что все можно будет найти тут в
//стэйте
@immutable
abstract class NewsState extends Equatable {}

// Исходное состояние
class NewsInitialState extends NewsState {
  @override
  List<Object?> get props => [];

}

// Загружено
class NewsLoadedState extends NewsState {
  NewsLoadedState({required this.listNews});

  final List<NewsModel> listNews;


  @override
  List<Object?> get props => [listNews];
}

// Загрузка
class NewsLoadingState extends NewsState {
  @override
  List<Object?> get props => [];
}

// Ошибка загрузки
class NewsLoadingFailureState extends NewsState {
  final String exception;

  NewsLoadingFailureState({required this.exception});

  @override
  List<Object?> get props => [exception];
}

enum NewsStatus {
  initial(),
  loaded(),
  loading(),
  failed(),
}

class NewsState extends Equatable {
  NewsState({
    required this.status,
    List<NewsModel>? listNews
  }) : _listNews = listNews ?? [];

  final NewsStatus status;
  final List<NewsModel> _listNews;


  //bool get isUserSubscribed => ;
  NewsState.initial()
      : this(
    status: NewsStatus.initial,
  );

  NewsState.loaded()
      : this(
    status: NewsStatus.loaded,
  );
 NewsState.unauthenticated() : this(status: NewsStatus.loading);

  @override
  List<Object?> get props => [
    status,
  ];

  NewsState copyWith({
    NewsStatus? status,
    bool? showLoginOverlay,
  }) {
    return NewsState(
      status: status ?? this.status,


    );
  }
}

