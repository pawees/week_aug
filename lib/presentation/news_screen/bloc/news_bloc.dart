import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clean_architecture_my_project/data/repositories/user_repositiry/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../app/presentation/bloc/app_bloc.dart';
import '../../../../data/repositories/news_repository/models/news_model.dart';
import '../../../../data/repositories/news_repository/news_repository.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(
      {required NewsRepository newsRepository,
      required UserRepository userRepository})
      : _newsRepository = newsRepository,
        _newsCount = 0,
        _stepCount = 3,
        super(NewsState.initial()) {
    ///обязательно добавить блок-конкаренси
    // concurrent - process events concurrently
    // sequential - process events sequentially
    // droppable - ignore any events added while an event is processing
    // restartable - process only the latest event and cancel previous event handlers
    on<GetListNewsEvent>(_onGetListNews, transformer: restartable());
    on<RequestNewsEvent>(
      _onRequestNews,
    );

    ///подписчик, который слушает изменения в стриме
    _userSubscription = userRepository.user.listen(_onUserChanged);
  }

  final NewsRepository _newsRepository;
  late StreamSubscription<AppStatus> _userSubscription;
  int _newsCount;
  final int _stepCount;

  Future<void> _onUserChanged(AppStatus update) async {
    try {
      if (update == AppStatus.unauthenticated) {
        _newsRepository.newsLimit = true;
      } else {
        _newsRepository.newsLimit = false;
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onRequestNews(
      RequestNewsEvent event, Emitter<NewsState> emit) async {
    try {
      emit(state.copyWith(status: NewsStatus.loaded));
      await _newsRepository.requestNews();
      add(GetListNewsEvent(true, event.offset));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NewsStatus.forbidden));
    }
  }

  Future<void> _onGetListNews(
      GetListNewsEvent event, Emitter<NewsState> emit) async {
    emit(state.copyWith(status: NewsStatus.loading));
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      _newsCount += _stepCount;
      final response =
          await _newsRepository.getNews(count: _newsCount, step: _stepCount);
      emit(state.copyWith(
          status: NewsStatus.loaded, listNews: response, offset: event.offset));
    } catch (error, stackTrace) {
        emit(state.copyWith(status: NewsStatus.failed));
        addError(error, stackTrace); //api blocА сообщение об ошибке


    }
  }
}
