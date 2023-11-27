import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/repositories/news_repository/models/news_model.dart';

import '../../../login/login_bloc.dart';

import '../../app/presentation/bloc/app_bloc.dart';
import 'bloc/news_bloc.dart';

//bloc builder
/// Виджет дерево главного экрана
class NewsScreenPage extends StatelessWidget {
  const NewsScreenPage({Key? key}) : super(key: key);

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

///news widgets
class _ViewNewsListWidget extends StatelessWidget {
  const _ViewNewsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //во вью лучше избегать всего кроме отображения
    //для операции +5 нужен отдельный слой(например вьюМодел(это блок,кубит,гетИкс,или просто свой контроллер))
    //если вруг придется подкинуть новую верстку, то эту логику +5 нужно все равно будет переносить
    //в другом случае просто подключаемся к вьюмоделу
    // void incrementNews(count) {
    //   count += 5;
    //   bloc.add(GetListNewsEvent(count, true));
    // }

    return BlocConsumer<NewsBloc, NewsState>(
        buildWhen: (preState, currState) => preState.status != currState.status,
        listener: (context, state) {
          if (state.status == NewsStatus.forbidden) {
            var snack = SnackBar(content: Text(NewsStatus.forbidden.message));
            ScaffoldMessenger.of(context).showSnackBar(snack);
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case NewsStatus.initial:
              return const SizedBox(
                height: 330,
                child: Center(child: CircularProgressIndicator()),
              );
            case NewsStatus.loading:
              return const SizedBox(
                height: 330,
                child: Center(child: CircularProgressIndicator()),
              );
            case NewsStatus.loaded:
              return NewsListWidget(
                newsList: state.listNews,
                offset: state.offset,
              );
            case NewsStatus.failed:
              return Shimmer.fromColors(
                  child: Container(
                    width: 50,
                    height: 70,
                  ),
                  baseColor: Colors.black54,
                  highlightColor: Colors.white70);
            case NewsStatus.forbidden:
              return NewsListWidget(
                newsList: state.listNews,
                offset: state.offset,
              );
          }
        });
  }
}

class NewsListWidget extends StatelessWidget {
  NewsListWidget({
    Key? key,
    required this.newsList,
    double offset = 0,

    ///двоеточие нужно чтобы опредедлить значение перед конструктором а потом в нем его использовать
    ///либо в методах
  })  : _offset = offset,
        super(key: key) {
    _scrollContr = ScrollController(
      initialScrollOffset: _offset,
    );
  }

  late ScrollController _scrollContr;
  List<NewsModel> newsList;
  double _offset;
  ///BlocSelector — это виджет Flutter, аналогичный BlocBuilder, но позволяющий разработчикам 
  ///фильтровать обновления, выбирая новое значение на основе текущего состояния блока. 
  ///Ненужные сборки предотвращаются, если выбранное значение не меняется.
  /// Выбранное значение должно быть неизменяемым, чтобы BlocSelector мог 
  /// точно определить, следует ли снова вызывать построитель. Если параметр блока опущен, 
  /// BlocSelector автоматически выполнит поиск с использованием BlocProvider и текущего BuildContext.
  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewsBloc, NewsState, List<NewsModel>>(
      selector: (state) {
        return state.listNews;
      },
      builder: (context, state) {
        return SizedBox(
          height: 330,
          child: ListView.builder(
            controller: _scrollContr,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            itemCount: newsList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == newsList.length) {
                return InkWell(
                  onTap: () => context
                      .read<NewsBloc>()
                      .add(RequestNewsEvent(_scrollContr.offset)),
                  child: ViewButtonWidget(
                    height: 300,
                    width: 150,
                    buttonIcon: Icon(Icons.add_circle,
                        color: Theme.of(context).colorScheme.inversePrimary),
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
      },
    );
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
  final String imageNews;
  final String dateNews;
  final String nameNews;

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
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 3.5,
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

class _ChangeUserButton extends StatefulWidget {
  const _ChangeUserButton({Key? key}) : super(key: key);

  @override
  State<_ChangeUserButton> createState() => _ChangeUserButtonState();
}

class _ChangeUserButtonState extends State<_ChangeUserButton> {
  List<bool> _toggleButtonsSelection = [false, true];

  @override
  Widget build(BuildContext context) {
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

///loading indicator
class _loadingIndicator extends StatefulWidget {
  const _loadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  State<_loadingIndicator> createState() => _loadingIndicatorState();
}

class _loadingIndicatorState extends State<_loadingIndicator> {
  Color color1 = Colors.white70;
  Color color2 = Colors.white70;
  Color color3 = Colors.white70;

  ///слушает изменения стэйтов сразу в нескольких блоках(в нашем случае в аппБлок и
  ///в Логин блок
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status == SubmissionStatus.success) {
              setState(() {
                color1 = Colors.white70;
                color2 = Colors.white70;
                color3 = Colors.white70;
              });
            }
            if (state.status == SubmissionStatus.inProgress) {
              setState(() {
                color1 = Colors.green;
                color2 = Colors.white70;
                color3 = Colors.black;
              });
            }
            // TODO: material set state
          },
        ),

        ///это виджет который реагрует на изменение стэйта в блоке
        ///используется для каких то задач сервисов, навигации модальных окон,
        ///но он не пересобирает виджет.В этом его отличие от blocBuilder.
        ///Вызывается единажды для каждого изменения состояния.
        BlocListener<AppBloc, AppState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == AppStatus.unauthenticated) {
                new Future.delayed(new Duration(seconds: 2), () {
                  setState(() {
                    color1 = Colors.white70;
                    color2 = Colors.white70;
                    color3 = Colors.white70;
                  });
                });
                setState(() {
                  color1 = Colors.red;
                  color2 = Colors.white70;
                  color3 = Colors.black;
                });
              }
            })
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 35,
          height: 19,
          child: LoadingIndicator(
              indicatorType: Indicator.ballBeat,

              /// Required, The loading type of the widget
              colors: [color1],

              /// Optional, The color collections
              strokeWidth: 5,

              /// Optional, The stroke of the line, only applicable to widget which contains line
              backgroundColor: color2,

              /// Optional, Background of the widget
              pathBackgroundColor: color3

              /// Optional, the stroke backgroundColor
              ),
        ),
      ),
    );
  }
}
