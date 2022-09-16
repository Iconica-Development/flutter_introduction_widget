import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/flutter_introduction_widget.dart';

void main() {
  runApp(const MaterialApp(home: FlutterIntroductionDemo()));
}

class FlutterIntroductionDemo extends StatelessWidget {
  const FlutterIntroductionDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(backgroundColor: Colors.amber),
        child: Introduction(
          introductionSettings: const IntroductionSettings(
            buttonMode: IntroductionScreenButtonMode.Text,
            showSkipButton: true,
            showFinishButton: true,
          ),
          onComplete: () {
            debugPrint('done!');
          },
          pages: [
            IntroductionPage(title: 'Page1', text: 'hello'),
            IntroductionPage(title: 'Page2', text: 'world'),
            IntroductionPage(title: 'Page3', text: 'text'),
          ],
        ),
      ),
    );
  }
}
