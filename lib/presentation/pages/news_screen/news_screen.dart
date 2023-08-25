import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../data/repositories/news_repository/models/news_model.dart';
import '../../../data/repositories/news_repository/news_repository.dart';
import '../../../data/repositories/user_repositiry/user_repository.dart';
import '../../../login/login_bloc.dart';
import '../../../resources/app_routes.dart';
import '../../../services/service_locator.dart';
import 'bloc/news_bloc.dart';

class NewsScreenPage extends StatelessWidget {
  const NewsScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsBloc>(
        create: (context) => NewsBloc(
            newsRepository: instanceStorage<NewsRepository>(),
            userRepository: instanceStorage<UserRepository>())
          ..add(const GetListNewsEvent(false)),
        child: const NewsScreenWidget());
  }
}

//bloc builder
/// Виджет дерево главного экрана
class NewsScreenWidget extends StatelessWidget {
  const NewsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const _ViewNewsListWidget(),
            _ChangeUserButton(),
            _loadingIndicator(),
          ],
        ),
      ),
    );
  }
}

class _loadingIndicator extends StatelessWidget {
  const _loadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status == SubmissionStatus.inProgress) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 35,
              height: 19,
              child: const LoadingIndicator(
                  indicatorType: Indicator.ballBeat,

                  /// Required, The loading type of the widget
                  colors: [Colors.green],

                  /// Optional, The color collections
                  strokeWidth: 5,

                  /// Optional, The stroke of the line, only applicable to widget which contains line
                  backgroundColor: Colors.white,

                  /// Optional, Background of the widget
                  pathBackgroundColor: Colors.black

                  /// Optional, the stroke backgroundColor
                  ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

//todo сделать кьюбит чтобы убрать все излишки
class _ChangeUserButton extends StatefulWidget {
  const _ChangeUserButton({Key? key}) : super(key: key);

  @override
  State<_ChangeUserButton> createState() => _ChangeUserButtonState();
}

class _ChangeUserButtonState extends State<_ChangeUserButton> {
  List<bool> _toggleButtonsSelection = [false, true];

  @override
  Widget build(BuildContext context) {
    //todo обновляет ли лисенер виджет?
    //todo вызывается один раз?
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          setState(() {
            _toggleButtonsSelection = [false, true];
          });
        } else if (state.status == AppStatus.authenticated) {
          setState(() {
            _toggleButtonsSelection = [true, false];
          });
        }
        // TODO: implement listener
      },
      child: ToggleButtons(
        children: [
          Text('Вход'),
          Text('Выход'),
        ],
        isSelected: _toggleButtonsSelection,
        onPressed: (int index) {
          if (index == 0) {
            context.read<LoginBloc>().add(LoginToggleSubmitted(password: ''));
          } else {
            context.read<AppBloc>().add(AppLogoutRequested());
          }
        },
      ),
    );
  }
}

// Виджет список карточек новостей
class _ViewNewsListWidget extends StatelessWidget {
  const _ViewNewsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<NewsModel> newsList = [];
    //во вью лучше избегать всего кроме отображения
    //для операции +5 нужен отдельный слой(например вьюМодел(это блок,кубит,гетИкс,или просто свой контроллер))
    //если вруг придется подкинуть новую верстку, то эту логику +5 нужно все равно будет переносить
    //в другом случае просто подключаемся к вьюмоделу
    // void incrementNews(count) {
    //   count += 5;
    //   bloc.add(GetListNewsEvent(count, true));
    // }

    return BlocConsumer<NewsBloc, NewsState>(
        buildWhen: (preState, currState) =>
            currState is !NewsLoadingFailureState,
        listener: (context, state) {
          if (state is NewsLoadingFailureState) {
            var snack = SnackBar(content: Text(state.exception));
            ScaffoldMessenger.of(context).showSnackBar(snack);

          }
        },
        builder: (context, state) {
          if (state is NewsInitialState) {
            return const Center(child: Text('Загрузить новости'));
          } else if (state is NewsLoadedState) {
            newsList = state.listNews;
            return SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                itemCount: newsList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == newsList.length) {
                    return InkWell(
                      onTap: () =>
                          context.read<NewsBloc>().add(GetListNewsEvent(true)),
                      child: const ViewButtonWidget(
                        height: 300,
                        width: 150,
                        buttonIcon:
                            Icon(Icons.add_circle, color: Colors.orange),
                      ),
                    );
                  }
                  return _CreateNewsListCardsWidget(
                    index: index,
                    listNews: newsList,
                  );
                },
              ),
            );
          } else if (state is NewsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SizedBox();
          }
        });
  }
}

// Конструктор списка карточек новостей
class _CreateNewsListCardsWidget extends StatelessWidget {
  final int index;
  final List<NewsModel> listNews;

  const _CreateNewsListCardsWidget(
      {Key? key, required this.index, required this.listNews})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final object = listNews[index];
    return _NewsWidget(
        imageNews: object.miniPhoto ?? '',
        dateNews: object.startDate ?? '',
        nameNews: object.title ?? '');
  }
} // класс создания карточек новостей

// Виджет карточки новости
class _NewsWidget extends StatelessWidget {
  final String imageNews; // фото новости
  final String dateNews; // дата новости
  final String nameNews; // текст новости

  const _NewsWidget({
    required this.imageNews,
    required this.dateNews,
    required this.nameNews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(17.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.white38,
            offset: Offset(0, 8),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
      width: 160,
      child: Column(
        children: [
          SizedBox(
            height: 140,
            width: 160,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(17.0),
                topLeft: Radius.circular(17.0),
              ),
              child: Image.network(
                imageNews,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(
                15,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        dateNews,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          nameNews,
                          softWrap: true,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// кнопка смотреть всё
class ViewButtonWidget extends StatelessWidget {
  final double height;
  final double width;
  final Widget buttonIcon;

  const ViewButtonWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(17.0)),
      ),
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(
          15,
        ),
        child: buttonIcon,
      ),
    );
  }
}
