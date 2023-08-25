import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../resources/app_routes.dart';
import '../../resources/app_values.dart';
import '../components/image_with_shimmer.dart';

class TestScreenTwoWidget extends StatelessWidget {
  const TestScreenTwoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text('TestScreenTwo'),
            const SizedBox(height: 20,),
            SizedBox(
              height: 400,
              width: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s8),
                child: const ImageWithShimmer(
                  imageUrl: 'https://avatars.mds.yandex.net/i?id=8b76585305f07488786fde02e727e0d3e3a26ec7-7754287-images-thumbs&n=13',
                  width: AppSize.s110,
                  height: double.infinity,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.goNamed(AppRoutes.testScreenThreeRoute),
              child: const Text('Перейти на testScreenThree'),),
          ],
        ),
      ),
    );
  }
}
