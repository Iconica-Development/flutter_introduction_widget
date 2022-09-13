import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/flutter_introduction_widget.dart';

void main() {
  runApp(const MaterialApp(home: FlutterIntroductionDemo()));
}

class FlutterIntroductionDemo extends StatelessWidget {
  const FlutterIntroductionDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var introImage = Image(
      color: Colors.black,
      image: const AssetImage(
        'assets/placeholder.png',
      ),
      width: MediaQuery.of(context).size.width / 1.8,
      height: MediaQuery.of(context).size.width / 1.8,
    );
    return Scaffold(
      body: IntroductionWidget(
        pages: [
          IntroductionPage(
            title: const Text('Digitale voortleven'),
            text: const Text(
              'Here stands some information about the subject. '
              'Here stands some information about the subject',
            ),
            image: introImage,
          ),
          IntroductionPage(
            title: const Text('Afscheidsfeestje'),
            text: const Text(
              'Here stands some information about the subject. '
              'Here stands some information about the subject.',
            ),
            image: introImage,
          ),
          IntroductionPage(
            title: const Text('Digitale kluis'),
            text: const Text(
              'Here stands some information about the subject. '
              'Here stands some information about the subject',
            ),
            image: introImage,
          ),
        ],
        onComplete: () {
          debugPrint('rout to next page');
        },
      ),
    );
  }
}
