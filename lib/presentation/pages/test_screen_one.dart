import 'package:flutter/material.dart';

import '../../resources/app_values.dart';
import '../components/image_with_shimmer.dart';

class TestScreenOneWidget extends StatelessWidget {
  const TestScreenOneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text('TestScreenOne'),
            const SizedBox(height: 20,),
            SizedBox(
              height: 400,
              width: 400,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s8),
                child: const ImageWithShimmer(
                  imageUrl: 'https://avatars.mds.yandex.net/i?id=8ec5b0664d7ad67082e8cab8fba098eafd38b2bd-9284609-images-thumbs&n=13',
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
