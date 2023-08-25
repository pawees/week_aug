import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clean_architecture_my_project/data/repositories/user_repositiry/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../app/bloc/app_bloc.dart';
import '../../../../data/repositories/news_repository/models/news_model.dart';
import '../../../../data/repositories/news_repository/news_repository.dart';



part 'news_event.dart';
part 'news_state.dart';

///final _newsScreenService = instanceStorage<NewsScreenService>();

//todo нужен объект для храения полученных данных и сравнения
class NewsBloc extends Bloc<NewsEvent, NewsState> {

  NewsBloc({required NewsRepository newsRepository,required UserRepository userRepository}) :
        _newsRepository = newsRepository,
        _newsCount = 0,
        _stepCount = 3,

        super(NewsInitialState()) {
    //обязательно добавить блок-конкаренси
    // concurrent - process events concurrently
    // sequential - process events sequentially
    // droppable - ignore any events added while an event is processing
    // restartable - process only the latest event and cancel previous event handlers
    on<GetListNewsEvent>(_onGetListNews, transformer: restartable());

    _userSubscription = userRepository.user.listen(_onUserChanged);

    /// Запрос на получение списка новостей при инициализации блока
    ///add(const GetListNewsEvent(3, false)); //указывается в другом месте
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

  //todo как оформить логику с данными(сравнивать, возвращать)
  Future<void> _onGetListNews(GetListNewsEvent event, Emitter<NewsState> emit) async {
    // // Проверка: если на экране уже есть загруженное состояние, MainScreenLoadingState не показываем
    // if (state is! NewsLoadedState){
    //   emit(NewsLoadingState());
    // }
    // // Если в сервисе уже хранится список новостей
    // if (_newsScreenService.newsList.isNotEmpty){
    //   try {
    //     await _newsScreenService.getListNewsMethod(event.count, event.sendRequest);
    //   } catch (e) {
    //     print('Error $e');
    //   } finally {
    //     /*
    //      В любом случае когда в сервисе хранится список новостей,
    //      даже если при запросе произошол сбой, берем список новостей
    //      хранящийся в сервисе
    //      */
    //     emit(NewsLoadedState(_newsScreenService.newsList));
    //   }
    //
    // } else {
    //   try {
    //     await _newsScreenService.getListNewsMethod(event.count, event.sendRequest);
    //     emit(NewsLoadedState(_newsScreenService.newsList));
    //   } catch (e) {
    //     emit(NewsLoadingFailureState(exception: e));
    //     print('Error $e');
    //   }
    // }
    //emit(NewsLoadingState());
    try {
      _newsCount += _stepCount;
      final response = await _newsRepository.getNews(count: _newsCount, step: _stepCount);
      emit(
        NewsLoadedState(
          listNews: response)
      );
    } catch (error, stackTrace) {
      emit(NewsLoadingFailureState(exception: 'Authorize that give move news...'));
      addError(error, stackTrace); //api blocА сообщение об ошибке
    }

  }

}
