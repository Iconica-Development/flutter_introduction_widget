// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

enum IntroductionScreenMode { showNever, showAlways, showOnce }

enum IntroductionScreenButtonMode { text, icon, disabled, singleFinish }

enum IntroductionLayoutStyle {
  imageCenter,
  imageTop,
  imageBottom,
}

enum IndicatorMode { dot, dash, custom }

enum IntroductionDisplayMode {
  singleScrollablePageVertical,
  multiPageHorizontal
}

enum IntroductionControlMode {
  previousNextButton,
  singleButton,
}

enum IntroductionButtonType {
  next,
  previous,
  finish,
  skip,
}

class IntroductionPage {
  final Widget? title;
  final Widget? text;
  final Widget? graphic;
  final BoxDecoration? decoration;
  final IntroductionLayoutStyle? layoutStyle;

  /// Creates an introduction page with data used in the introduction screen for
  /// each page.
  ///
  /// The values for [title] and [text] are optional in this, but will use a
  /// default translation key when built.
  ///
  /// The [background] is fully optional and if not provided will show the
  /// [ThemeData.colorScheme.background] as default.
  IntroductionPage({
    this.title,
    this.text,
    this.graphic,
    this.decoration,
    this.layoutStyle,
  });
}

class IntroductionOptions {
  /// Determine when the introduction screens needs to be shown.
  /// [IntroductionScreenMode.showNever] To disable introduction screens.
  /// [IntroductionScreenMode.showAlways] To always show the introduction screens on startup.
  /// [IntroductionScreenMode.showOnce] To only show the introduction screens once on startup.
  final IntroductionScreenMode mode;

  /// List of introduction pages to set the text, icons or images for the introduction screens.
  final List<IntroductionPage> pages;

  /// Determines whether the user can tap the screen to go to the next introduction screen.
  final bool tapEnabled;

  /// Determines what kind of buttons are used to navigate to the next introduction screen.
  /// Introduction screens can always be navigated by swiping (or tapping if [tapEnabled] is enabled).
  /// [IntroductionScreenButtonMode.text] Use text buttons (text can be set by setting the translation key or using the default appshell translations).
  /// [IntroductionScreenButtonMode.icon] Use icon buttons (icons can be changed by providing a icon library)
  /// [IntroductionScreenButtonMode.disabled] Disable buttons.
  final IntroductionScreenButtonMode buttonMode;

  /// Determines the position of the provided images or icons that are set using [pages].
  /// Every introduction page provided with a image or icon will use the same layout setting.
  /// [IntroductionLayoutStyle.imageCenter] Image/icon will be at the center of the introduction page.
  /// [IntroductionLayoutStyle.imageTop] Image/icon will be at the top of the introduction page.
  /// [IntroductionLayoutStyle.imageBottom] Image/icon will be at the bottom of the introduction page.
  final IntroductionLayoutStyle layoutStyle;

  /// Determines the style of the page indicator shown at the bottom on the introduction pages.
  /// [IndicatorMode.dot] Shows a dot for each page.
  /// [IndicatorMode.dash] Shows a dash for each page.
  /// [IndicatorMode.custom] calls indicatorBuilder for the indicator
  final IndicatorMode indicatorMode;

  /// Builder that is called when [indicatorMode] is set to [IndicatorMode.custom]
  final Widget Function(
    BuildContext,
    PageController,
    int,
    int,
  )? indicatorBuilder;

  /// Determines whether the user can skip the introduction pages using a button
  /// in the header
  final bool skippable;

  /// Determines whether the introduction screens should be shown in a single
  final TextAlign textAlign;

  /// [IntroductionDisplayMode.multiPageHorizontal] Configured introduction pages will be shown on seperate screens and can be navigated using using buttons (if enabled) or swiping.
  /// !Unimplemented! [IntroductionDisplayMode.singleScrollablePageVertical] All configured introduction pages will be shown on a single scrollable page.
  ///
  final IntroductionDisplayMode displayMode;

  /// When [IntroductionDisplayMode.multiPageHorizontal] is selected multiple controlMode can be selected.
  /// [IntroductionControlMode.previousNextButton] shows two buttons at the bottom of the screen to return or proceed. The skip button is placed at the top left of the screen.
  /// [IntroductionControlMode.singleButton] contains one button at the bottom of the screen to proceed. Underneath is clickable text to skip if the current page is the first page. If the current page is any different it return to the previous screen.
  ///
  final IntroductionControlMode controlMode;

  /// A builder that can be used to replace the default text buttons when
  /// [IntroductionScreenButtonMode.text] is provided to [buttonMode]
  final Widget Function(
          BuildContext, VoidCallback, Widget, IntroductionButtonType)?
      buttonBuilder;

  /// The translations for all buttons on the introductionpages
  ///
  /// See [IntroductionTranslations] for more information
  /// The following buttons have a translation:
  /// - Skip
  /// - Next
  /// - Previous
  /// - Finish
  final IntroductionTranslations introductionTranslations;

  const IntroductionOptions({
    this.introductionTranslations = const IntroductionTranslations(),
    this.indicatorMode = IndicatorMode.dash,
    this.indicatorBuilder,
    this.layoutStyle = IntroductionLayoutStyle.imageCenter,
    this.pages = const [],
    this.buttonMode = IntroductionScreenButtonMode.disabled,
    this.tapEnabled = false,
    this.mode = IntroductionScreenMode.showNever,
    this.textAlign = TextAlign.center,
    this.displayMode = IntroductionDisplayMode.multiPageHorizontal,
    this.skippable = false,
    this.buttonBuilder,
    this.controlMode = IntroductionControlMode.previousNextButton,
  }) : assert(
          !(identical(indicatorMode, IndicatorMode.custom) &&
              indicatorBuilder == null),
          'When indicator mode is set to custom, '
          'make sure to define indicatorBuilder',
        );

  IntroductionOptions copyWith({
    IntroductionScreenMode? mode,
    List<IntroductionPage>? pages,
    bool? tapEnabled,
    IntroductionScreenButtonMode? buttonMode,
    IntroductionLayoutStyle? layoutStyle,
    IndicatorMode? indicatorMode,
    Widget Function(
      BuildContext,
      PageController,
      int,
      int,
    )? indicatorBuilder,
    bool? skippable,
    TextAlign? textAlign,
    IntroductionDisplayMode? displayMode,
    IntroductionControlMode? controlMode,
    Widget Function(BuildContext, VoidCallback, Widget, IntroductionButtonType)?
        buttonBuilder,
    IntroductionTranslations? introductionTranslations,
  }) {
    return IntroductionOptions(
      mode: mode ?? this.mode,
      pages: pages ?? this.pages,
      tapEnabled: tapEnabled ?? this.tapEnabled,
      buttonMode: buttonMode ?? this.buttonMode,
      layoutStyle: layoutStyle ?? this.layoutStyle,
      indicatorMode: indicatorMode ?? this.indicatorMode,
      indicatorBuilder: indicatorBuilder ?? this.indicatorBuilder,
      skippable: skippable ?? this.skippable,
      textAlign: textAlign ?? this.textAlign,
      displayMode: displayMode ?? this.displayMode,
      controlMode: controlMode ?? this.controlMode,
      buttonBuilder: buttonBuilder ?? this.buttonBuilder,
      introductionTranslations:
          introductionTranslations ?? this.introductionTranslations,
    );
  }
}

///
class IntroductionTranslations {
  final String skipButton;
  final String nextButton;
  final String previousButton;
  final String finishButton;

  const IntroductionTranslations({
    this.skipButton = 'skip',
    this.nextButton = 'next',
    this.previousButton = 'previous',
    this.finishButton = 'finish',
  });
}
