import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/promo_repository/models/promo_model.dart';
import '../../../resources/app_routes.dart';
import '../../../utils/enums.dart';
import '../../news_screen/news_screen.dart';
import 'bloc/promo_bloc.dart';



class PromoScreenPage extends StatelessWidget {
  const PromoScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              const _ViewPromoListWidget(),
              const SizedBox(height: 30,),
              TextButton(
                onPressed: () => context.goNamed(AppRoutes.testScreenTwoRoute),
                child: const Text('Перейти на testScreenTwo'),)
            ],
          ),
        ),
      ),
    );
  }
}


class _ViewPromoListWidget extends StatelessWidget {
  const _ViewPromoListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PromoBloc>(context);

    void incrementNews(count) {
      count += 5;
      bloc.add(GetListPromoEvent(count, true));
    }

    return BlocBuilder<PromoBloc, PromoState>(
      builder: (context, state) {
        final updateProgress = context.select((PromoBloc bloc) => bloc.state.updateProgress,);
        switch (state.status) {
          case RequestStatus.loading://
            return const Center(child: CircularProgressIndicator());
          case RequestStatus.error:
            return Center(
                child: Column(
                  children: [
                    const Text('Произошла ошибка, попробуйте снова'),
                    TextButton(
                      onPressed: () => bloc.add(const GetListPromoEvent(3, false)),
                      child: const Text('Обновить'),)
                  ],
                ));
          case RequestStatus.loaded:
            return SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                itemCount: state.listPromo.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == state.listPromo.length) {
                    return InkWell(
                      onTap: () => incrementNews(state.listPromo.length),
                      child: ViewButtonWidget(
                        height: 320,
                        width: 150,
                        buttonIcon: updateProgress ?
                        const Center(child: SizedBox(
                          height: 25,
                          width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                              strokeWidth: 3,
                            ))) : const Icon(
                            Icons.add_circle,
                            color: Colors.orange),
                      ),
                    );
                  } else {
                    return _CreatePromoListCardsWidget(
                      index: index,
                      listPromo: state.listPromo,);
                  }
                },
              ),
            );
        }
      },
    );
  }}


class _CreatePromoListCardsWidget extends StatelessWidget {
  final int index;
  final List<PromoModel> listPromo;

  const _CreatePromoListCardsWidget({Key? key,
    required this.index,
    required this.listPromo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final object = listPromo[index];
    return PromoWidget(
      imagePromo: object.miniPhoto ?? '',
      endDate: object.endDate ?? '',
      namePromo: object.title ?? '',
      startDate: object.startDate ?? '',
    );
  }
}

class PromoWidget extends StatelessWidget {
  final String imagePromo; 
  final String startDate; 
  final String endDate; 
  final String namePromo;

  const PromoWidget({
    super.key,
    required this.imagePromo,
    required this.startDate,
    required this.endDate,
    required this.namePromo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(17.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white10,
            offset: Offset(0, 8),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
      width: 220,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 220,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(17.0),
                topLeft: Radius.circular(17.0),
              ),
              child: Image.network(
                imagePromo,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8, right: 12, top: 8, left: 12,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(
                                width: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    endDate.isEmpty ? 'с $startDate' : 'по $endDate',
                                    
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          namePromo,
                          softWrap: true,
                          maxLines: 2,
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
} // акция