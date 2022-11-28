[![pub package](https://img.shields.io/pub/v/flutter_introduction_widget.svg)](https://github.com/Iconica-Development) [![Build status](https://img.shields.io/github/workflow/status/Iconica-Development/flutter_introduction_widget/CI)](https://github.com/Iconica-Development/flutter_introduction_widget/actions/new) [![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart) 

# Introduction Widget
Flutter Introduction Widget for showing a list of introduction pages on a single scrollable page or horizontal pageview.

![Introduction GIF](flutter_introduction_widget.gif)

## Setup

To use this package, add `flutter_introduction_widget` as a dependency in your pubspec.yaml file.

## How to use

Simple way to use the introduction widget:
```dart
IntroductionScreen(
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
                backgroundImage: const AssetImage(
                  'assets/flutter_introduction_background.jpeg'),
            ),
        ],
        introductionTranslations: const IntroductionTranslations(
            skipButton: 'Skip it!',
            nextButton: 'Next',
            previousButton: 'Previous',
            finishButton: 'Finish',
        ),
        buttonMode: IntroductionScreenButtonMode.text,
        buttonBuilder: (context, onPressed, child) =>
            ElevatedButton(onPressed: onPressed, child: child),
    ),
    onComplete: () {
        debugPrint('We completed the cycle');
    },
),
``` 

See the [Example Code](example/lib/main.dart) for an example on how to use this package.

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_introduction_widget) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](./CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_introduction_widget/pulls).

## Author

This `flutter_introduction_widget` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>