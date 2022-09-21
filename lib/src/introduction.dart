import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/types/page_introduction.dart';
import 'package:flutter_introduction_widget/src/types/single_introduction.dart';

import 'config/introduction.dart';

const kAnimationDuration = Duration(milliseconds: 300);

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({
    Key? key,
    required this.options,
    required this.onComplete,
    this.physics,
    this.onNext,
    this.onPrevious,
    this.onSkip,
  }) : super(key: key);

  /// The options used to build the introduction screen
  final IntroductionOptions options;

  /// A function called when the introductionSceen changes
  final VoidCallback onComplete;

  /// A function called when the introductionScreen is skipped
  final VoidCallback? onSkip;
  final ScrollPhysics? physics;

  /// A function called when the introductionScreen moved to the next page
  /// where the page provided is the page where the user currently moved to
  final void Function(IntroductionPage)? onNext;

  /// A function called when the introductionScreen moved to the previous page
  /// where the page provided is the page where the user currently moved to
  final void Function(IntroductionPage)? onPrevious;

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          switch (widget.options.displayMode) {
            case IntroductionDisplayMode.multiPageHorizontal:
              return MultiPageIntroductionScreen(
                onComplete: widget.onComplete,
                physics: widget.physics,
                onSkip: widget.onSkip,
                onPrevious: widget.onPrevious,
                onNext: widget.onNext,
                options: widget.options,
              );
            case IntroductionDisplayMode.singleScrollablePageVertical:
              return SingleIntroductionPage(
                options: widget.options,
              );
          }
        },
      ),
    );
  }
}
