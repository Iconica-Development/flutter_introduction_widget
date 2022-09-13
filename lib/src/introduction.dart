import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/models/introduction_page.dart';

enum IndicatorMode { dot, dash, custom }

class IntroductionWidget extends StatefulWidget {
  const IntroductionWidget({
    required this.pages,
    required this.onComplete,
    this.skippable = true,
    this.slideEnabled = true,
    this.indicatorMode = IndicatorMode.dot,
    this.onSkip,
    this.onNext,
    this.onPrevious,
    this.physics,
    this.controller,
    super.key,
  });

  final List<IntroductionPage> pages;

  final bool skippable;

  final bool slideEnabled;

  final IndicatorMode indicatorMode;

  final VoidCallback onComplete;

  final VoidCallback? onSkip;

  final void Function(IntroductionPage)? onNext;

  final void Function(IntroductionPage)? onPrevious;

  final ScrollPhysics? physics;

  final PageController? controller;

  @override
  State<IntroductionWidget> createState() => _IntroductionWidgetState();
}

class _IntroductionWidgetState extends State<IntroductionWidget> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ?? PageController();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: widget.physics,
      controller: _pageController,
      children: List.generate(widget.pages.length, _buildPage),
    );
  }

  Widget _buildPage(int index) {
    return Column(
      children: [
        Expanded(
          child: widget.pages[index].content ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.pages[index].image ?? const SizedBox(),
                  widget.pages[index].title ?? const SizedBox(),
                  widget.pages[index].text ?? const SizedBox(),
                ],
              ),
        ),
      ],
    );
  }
}
