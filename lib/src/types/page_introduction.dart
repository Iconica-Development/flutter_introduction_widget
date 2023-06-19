// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/introduction.dart';

import '../config/introduction.dart';
import '../widgets/background.dart';
import '../widgets/indicator.dart';
import '../widgets/page_content.dart';

class MultiPageIntroductionScreen extends StatefulWidget {
  const MultiPageIntroductionScreen({
    required this.options,
    required this.onComplete,
    this.physics,
    this.onNext,
    this.onPrevious,
    this.onSkip,
    Key? key,
  }) : super(key: key);

  final VoidCallback onComplete;
  final VoidCallback? onSkip;
  final void Function(IntroductionPage)? onNext;
  final void Function(IntroductionPage)? onPrevious;
  final ScrollPhysics? physics;

  final IntroductionOptions options;

  @override
  State<MultiPageIntroductionScreen> createState() =>
      _MultiPageIntroductionScreenState();
}

class _MultiPageIntroductionScreenState
    extends State<MultiPageIntroductionScreen> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    _currentPage.value = _controller.page?.round() ?? 0;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pages = widget.options.pages;
    var translations = widget.options.introductionTranslations;
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is OverscrollNotification) {
              if (notification.overscroll > 8) {
                widget.onComplete.call();
              }
            }
            // add bouncing scroll physics support
            if (notification is ScrollUpdateNotification) {
              final offset = notification.metrics.pixels;
              if (offset > notification.metrics.maxScrollExtent + 8) {
                widget.onComplete.call();
              }
            }
            return false;
          },
          child: PageView(
            controller: _controller,
            physics: widget.physics,
            children: List.generate(
              pages.length,
              (index) {
                return ExplainerPage(
                  onTap: () {
                    widget.onNext?.call(pages[_currentPage.value]);
                  },
                  controller: _controller,
                  page: pages[index],
                  options: widget.options,
                  index: index,
                );
              },
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.options.controlMode ==
                  IntroductionControlMode.previousNextButton) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    height: 64,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.options.skippable &&
                                !_isLast(pages)) ...[
                              TextButton(
                                onPressed: widget.onComplete,
                                child: Text(translations.skipButton),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox.shrink()
              ],
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _currentPage,
                      builder: (context, _) => Indicator(
                        indicatorBuilder: widget.options.indicatorBuilder,
                        mode: widget.options.indicatorMode,
                        controller: _controller,
                        count: pages.length,
                        index: _currentPage.value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          if (widget.options.controlMode ==
                              IntroductionControlMode.singleButton) {
                            return IntroductionOneButton(
                              controller: _controller,
                              next: _isNext(pages),
                              previous: _isPrevious,
                              last: _isLast(pages),
                              options: widget.options,
                              onFinish: widget.onComplete,
                              onNext: () {
                                widget.onNext?.call(pages[_currentPage.value]);
                              },
                              onPrevious: () {
                                widget.onNext?.call(pages[_currentPage.value]);
                              },
                            );
                          }

                          return IntroductionTwoButtons(
                            controller: _controller,
                            next: _isNext(pages),
                            previous: _isPrevious,
                            last: _isLast(pages),
                            options: widget.options,
                            onFinish: widget.onComplete,
                            onNext: () {
                              widget.onNext?.call(pages[_currentPage.value]);
                            },
                            onPrevious: () {
                              widget.onNext?.call(pages[_currentPage.value]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return IntroductionIconButtons(
                controller: _controller,
                next: _isNext(pages),
                previous: _isPrevious,
                last: _isLast(pages),
                options: widget.options,
                onFinish: widget.onComplete,
                onNext: () {
                  widget.onNext?.call(pages[_currentPage.value]);
                },
                onPrevious: () {
                  widget.onNext?.call(pages[_currentPage.value]);
                },
              );
            }),
      ],
    );
  }

  bool _isLast(List<IntroductionPage> pages) =>
      _currentPage.value == pages.length - 1;

  bool get _isPrevious => _currentPage.value > 0;

  bool _isNext(List<IntroductionPage> pages) =>
      _currentPage.value < pages.length - 1;
}

class ExplainerPage extends StatelessWidget {
  const ExplainerPage({
    required this.page,
    required this.options,
    required this.index,
    required this.controller,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final IntroductionPage page;
  final IntroductionOptions options;
  final PageController controller;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Background(
      background: page.decoration,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            Expanded(
              child: IntroductionPageContent(
                onTap: () {
                  if (options.tapEnabled) {
                    onTap?.call();
                  }
                },
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: DefaultTextStyle(
                    style: theme.textTheme.displayMedium!,
                    child: page.title ?? Text('introduction.$index.title'),
                  ),
                ),
                text: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: DefaultTextStyle(
                    style: theme.textTheme.bodyLarge!,
                    child: page.text ?? Text('introduction.$index.description'),
                  ),
                ),
                graphic: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: page.graphic,
                  ),
                ),
                layoutStyle: page.layoutStyle ?? options.layoutStyle,
              ),
            ),
            const SizedBox(
              height: 144,
            ),
          ],
        ),
      ),
    );
  }
}

class IntroductionTwoButtons extends StatelessWidget {
  const IntroductionTwoButtons({
    required this.options,
    required this.controller,
    required this.next,
    required this.last,
    required this.previous,
    required this.onFinish,
    required this.onNext,
    required this.onPrevious,
    Key? key,
  }) : super(key: key);

  final IntroductionOptions options;
  final PageController controller;
  final VoidCallback? onFinish;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  final bool previous;
  final bool next;
  final bool last;

  void _previous() {
    controller.previousPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
    );
    onPrevious?.call();
  }

  @override
  Widget build(BuildContext context) {
    var translations = options.introductionTranslations;
    var showFinishButton =
        options.buttonMode == IntroductionScreenButtonMode.singleFinish;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (options.buttonMode == IntroductionScreenButtonMode.text) ...[
          if (previous) ...[
            options.buttonBuilder?.call(
                  context,
                  _previous,
                  Text(translations.previousButton),
                  IntroductionButtonType.previous,
                ) ??
                TextButton(
                  onPressed: _previous,
                  child: Text(translations.previousButton),
                ),
          ] else
            const SizedBox.shrink(),
          if (next) ...[
            options.buttonBuilder?.call(
                  context,
                  _next,
                  Text(translations.nextButton),
                  IntroductionButtonType.next,
                ) ??
                TextButton(
                  onPressed: _next,
                  child: Text(translations.nextButton),
                ),
          ] else if (last) ...[
            options.buttonBuilder?.call(
                  context,
                  () {
                    onFinish?.call();
                  },
                  Text(translations.finishButton),
                  IntroductionButtonType.finish,
                ) ??
                TextButton(
                  onPressed: () {
                    onFinish?.call();
                  },
                  child: Text(translations.finishButton),
                ),
          ] else ...[
            const SizedBox.shrink(),
          ],
        ] else if (showFinishButton) ...[
          const SizedBox.shrink(),
          Expanded(
            child: Visibility(
              visible: last,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              maintainInteractivity: false,
              child: Align(
                child: options.buttonBuilder?.call(
                      context,
                      () {
                        onFinish?.call();
                      },
                      Text(translations.finishButton),
                      IntroductionButtonType.finish,
                    ) ??
                    ElevatedButton(
                      onPressed: () {
                        onFinish?.call();
                      },
                      child: Text(translations.finishButton),
                    ),
              ),
            ),
          ),
          const SizedBox.shrink(),
        ],
      ],
    );
  }

  _next() {
    controller.nextPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
    );
    onNext?.call();
  }
}

class IntroductionOneButton extends StatelessWidget {
  const IntroductionOneButton({
    required this.options,
    required this.controller,
    required this.next,
    required this.last,
    required this.previous,
    required this.onFinish,
    required this.onNext,
    required this.onPrevious,
    Key? key,
  }) : super(key: key);

  final IntroductionOptions options;
  final PageController controller;
  final VoidCallback? onFinish;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  final bool previous;
  final bool next;
  final bool last;

  void _previous() {
    controller.previousPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
    );
    onPrevious?.call();
  }

  @override
  Widget build(BuildContext context) {
    var translations = options.introductionTranslations;

    return Column(
      children: [
        if (options.buttonMode == IntroductionScreenButtonMode.text) ...[
          if (last) ...[
            options.buttonBuilder?.call(
                  context,
                  () {
                    onFinish?.call();
                  },
                  Text(translations.finishButton),
                  IntroductionButtonType.finish,
                ) ??
                TextButton(
                  onPressed: () {
                    onFinish?.call();
                  },
                  child: Text(translations.finishButton),
                ),
          ] else ...[
            options.buttonBuilder?.call(
                  context,
                  _next,
                  Text(translations.nextButton),
                  IntroductionButtonType.next,
                ) ??
                TextButton(
                  onPressed: _next,
                  child: Text(translations.nextButton),
                ),
          ],
          if (previous) ...[
            options.buttonBuilder?.call(
                  context,
                  _previous,
                  Text(translations.previousButton),
                  IntroductionButtonType.previous,
                ) ??
                TextButton(
                  onPressed: _previous,
                  child: Text(translations.previousButton),
                ),
          ] else ...[
            options.buttonBuilder?.call(
                  context,
                  () {
                    onFinish?.call();
                  },
                  Text(translations.finishButton),
                  IntroductionButtonType.skip,
                ) ??
                TextButton(
                  onPressed: () {
                    onFinish?.call();
                  },
                  child: Text(translations.finishButton),
                ),
          ],
        ],
      ],
    );
  }

  _next() {
    controller.nextPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
    );
    onNext?.call();
  }
}

class IntroductionIconButtons extends StatelessWidget {
  const IntroductionIconButtons({
    required this.options,
    required this.controller,
    required this.next,
    required this.last,
    required this.previous,
    required this.onFinish,
    required this.onNext,
    required this.onPrevious,
    Key? key,
  }) : super(key: key);

  final IntroductionOptions options;
  final PageController controller;
  final VoidCallback? onFinish;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  final bool previous;
  final bool next;
  final bool last;

  void _previous() {
    controller.previousPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
    );
    onPrevious?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (options.buttonMode == IntroductionScreenButtonMode.icon) ...[
            if (previous) ...[
              IconButton(
                iconSize: 70,
                onPressed: _previous,
                icon: const Icon(Icons.chevron_left),
              ),
            ] else
              const SizedBox.shrink(),
            IconButton(
              iconSize: 70,
              onPressed: () {
                if (next) {
                  _next();
                } else {
                  onFinish?.call();
                }
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ],
      ),
    );
  }

  _next() {
    controller.nextPage(
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
    );
    onNext?.call();
  }
}
