part of 'news_bloc.dart';


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


