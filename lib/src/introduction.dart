import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/models/introduction_page.dart';
import 'package:flutter_introduction_widget/src/widgets/indicator.dart';

enum IndicatorMode { dot, dash, custom }

class IntroductionWidget extends StatefulWidget {
  const IntroductionWidget({
    required this.pages,
    required this.onComplete,
    this.skippable = true,
    this.slideEnabled = true,
    this.indicatorMode = IndicatorMode.dash,
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
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ?? PageController();
    _pageController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handleScroll);
    if (widget.controller == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  void _handleScroll() {
    if (mounted) {
      _currentPage.value = _pageController.page?.round() ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          physics: widget.physics,
          controller: _pageController,
          children: List.generate(widget.pages.length, _buildPage),
        ),
        SafeArea(
          child: Column(
            children: [
              Text('Skip'),
              const Spacer(),
              AnimatedBuilder(
                animation: _currentPage,
                builder: (context, _) => Indicator(
                  mode: widget.indicatorMode,
                  controller: _pageController,
                  count: widget.pages.length,
                  index: _currentPage.value,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(32),
              //   child: AnimatedBuilder(
              //     animation: _pageController,
              //     builder: (context, _) => IntroductionButtons(
              //       controller: _controller,
              //       next: _currentPage.value < pages.length - 1,
              //       previous: _currentPage.value > 0,
              //       last: _currentPage.value == pages.length - 1,
              //       options: widget.options,
              //       onFinish: widget.onComplete,
              //       onNext: () {
              //         widget.onNext?.call(pages[_currentPage.value]);
              //       },
              //       onPrevious: () {
              //         widget.onNext?.call(pages[_currentPage.value]);
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
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
