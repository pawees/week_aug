import 'package:flutter/material.dart';

import '../../resources/app_values.dart';
import '../components/image_with_shimmer.dart';

class TestScreenThreeWidget extends StatelessWidget {
  const TestScreenThreeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text('TestScreenThree'),
            const SizedBox(height: 20,)
,            SizedBox(
          height: 400,
          width: 400,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s8),
            child: const ImageWithShimmer(
              imageUrl: 'https://avatars.mds.yandex.net/i?id=32b3985477d9b6fb7da0c96eff6b85b75b251727-10415036-images-thumbs&n=13',
              width: AppSize.s110,
              height: double.infinity,
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}

