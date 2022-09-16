// ignore_for_file: constant_identifier_names

library introduction_screen;

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

enum IndicatorMode { Dot, Dash }

enum IntroductionScreenMode { ShowNever, ShowAlways, ShowOnce }

enum IntroductionScreenButtonMode { Text, Icon, Disabled }

enum IntroductionLayoutStyle {
  ImageCenter,
  ImageTop,
  ImageBottom,
}

class IntroductionPage {
  /// Creates an introduction page with data used in the introduction screen
  /// for each page.
  ///
  /// The values for [title] and [text] are optional in this, but will use a
  /// default translation key when built. [image], [icon] and [animation] are
  /// interchangeable, where the order of priority
  /// is [animation] > [image] > [icon]
  ///
  /// The [backgroundImage] is fully optional and if not provided will show the
  /// [ThemeData.backgroundColor] as default.
  IntroductionPage({
    this.title,
    this.text,
    this.image,
    this.backgroundImage,
    this.icon,
    this.animation,
  });
  final String? title;
  final String? text;
  final String? image;
  final String? backgroundImage;
  final RiveAnimation? animation;
  final IconData? icon;
}

class IntroductionSettings {
  const IntroductionSettings({
    this.showFinishButton,
    this.showSkipButton = true,
    this.introductionTapEnabled,
    this.introductionIndicatorMode = IndicatorMode.Dot,
    this.introductionTextAlign = TextAlign.center,
    this.buttonMode,
    this.layoutStyle,
  });
  final bool? showFinishButton;
  final bool showSkipButton;
  final bool? introductionTapEnabled;
  final TextAlign introductionTextAlign;
  final IndicatorMode introductionIndicatorMode;
  final IntroductionScreenButtonMode? buttonMode;
  final IntroductionLayoutStyle? layoutStyle;

  IntroductionSettings copyWith({
    bool? showFinishButton,
    bool? showSkipButton,
    bool? introductionTapEnabled,
    TextAlign? introductionTextAlign,
    IndicatorMode? introductionIndicatorMode,
    IntroductionScreenButtonMode? buttonMode,
    IntroductionLayoutStyle? layoutStyle,
  }) {
    return IntroductionSettings(
      showFinishButton: showFinishButton ?? this.showFinishButton,
      showSkipButton: showSkipButton ?? this.showSkipButton,
      introductionTapEnabled:
          introductionTapEnabled ?? this.introductionTapEnabled,
      introductionTextAlign:
          introductionTextAlign ?? this.introductionTextAlign,
      introductionIndicatorMode:
          introductionIndicatorMode ?? this.introductionIndicatorMode,
      buttonMode: buttonMode ?? this.buttonMode,
      layoutStyle: layoutStyle ?? this.layoutStyle,
    );
  }
}
