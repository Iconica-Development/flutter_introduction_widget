import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/flutter_introduction_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: IntroductionScreen(
        options: IntroductionOptions(
          pages: [
            IntroductionPage(
              title: const Text('First page'),
              text: const Text('Wow a page'),
              graphic: const FlutterLogo(),
            ),
            IntroductionPage(
              title: const Text('Second page'),
              text: const Text('Another page'),
              graphic: const FlutterLogo(),
            ),
            IntroductionPage(
              title: const Text('Third page'),
              text: const Text('The final page of this app'),
              graphic: const FlutterLogo(),
              backgroundImage: const NetworkImage(
                'https://iconica.nl/wp-content/uploads/2021/12/20210928-_CS17127-1-2048x1365.jpg',
              ),
            ),
          ],
          introductionTranslations: const IntroductionTranslations(
            skipButton: 'Skip it!',
            nextButton: 'Next',
            previousButton: 'Previous',
            finishButton: 'To the app!',
          ),
          tapEnabled: true,
          displayMode: IntroductionDisplayMode.multiPageHorizontal,
          buttonMode: IntroductionScreenButtonMode.text,
          indicatorMode: IndicatorMode.dash,
          skippable: true,
          buttonBuilder: (introductionButton, context, onPressed, child) =>
              ElevatedButton(onPressed: onPressed, child: child),
        ),
        onComplete: () {
          debugPrint('We completed the cycle');
        },
      ),
    );
  }
}
