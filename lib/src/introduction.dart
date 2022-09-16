// ignore_for_file: prefer_mixin

import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/extensions.dart';
import 'package:flutter_introduction_widget/src/models/defaults.dart';
import 'package:flutter_introduction_widget/src/widgets/dash_indicator.dart';
import 'package:flutter_introduction_widget/src/widgets/dots_indicator.dart';
import 'package:flutter_introduction_widget/src/widgets/shadow_icon.dart';
import 'models/introduction_page.dart';

class Introduction extends StatefulWidget {
  const Introduction({
    this.child,
    this.onComplete,
    this.pages,
    this.introductionSettings = const IntroductionSettings(),
    super.key,
  }) : assert(
          !(child == null && onComplete == null),
          'Either child or onComplete must be provided',
        );
  final Widget? child;
  final List<IntroductionPage>? pages;
  final VoidCallback? onComplete;
  final IntroductionSettings introductionSettings;

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> with NavigateWidgetMixin {
  List<IntroductionPage> pages = [];
  int _currentpage = 0;
  final PageController _controller = PageController();
  late TextAlign textAlign;
  IntroductionSettings introductionSettings = const IntroductionSettings();

  @override
  void initState() {
    introductionSettings = widget.introductionSettings;
    _controller.addListener(
      () {
        setState(
          () {
            _currentpage = _controller.page!.toInt();
          },
        );
      },
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var confPages = widget.pages;
      setState(() {
        if (widget.pages != null) {
          pages = widget.pages!;
        } else if (confPages != null && confPages.isNotEmpty) {
          pages = confPages;
        } else {
          pages = getDefaultPages();
        }
        textAlign = [].contains(widget.introductionSettings.layoutStyle)
            ? TextAlign.center
            : TextAlign.left;

        introductionSettings = widget.introductionSettings.copyWith(
          buttonMode: widget.introductionSettings.buttonMode,
          showSkipButton: widget.introductionSettings.showSkipButton,
          showFinishButton: widget.introductionSettings.showFinishButton,
          layoutStyle: widget.introductionSettings.layoutStyle,
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onComplete() async {
    widget.onComplete?.call();
  }

  void _handleTapUp(TapUpDetails details) {
    if (introductionSettings.introductionTapEnabled ?? false) {
      if (details.globalPosition.dx / MediaQuery.of(context).size.width > 0.5) {
        if (_controller.page!.toInt() < pages.length - 1) {
          _controller.animateToPage(
            _controller.page!.floor() + 1,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
          );
        } else {
          _onComplete();
        }
      } else {
        if (_controller.page!.toInt() > 0) {
          _controller.animateToPage(
            _controller.page!.floor() - 1,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    }
  }

  void _handleHorizontalDrag(DragUpdateDetails details) {
    if (details.primaryDelta! < 0) {
      if (_controller.page!.toInt() < pages.length - 1) {
        _controller.animateToPage(
          _controller.page!.floor() + 1,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        _onComplete();
      }
    } else if (details.primaryDelta! > 0) {
      if (_controller.page!.toInt() > 0) {
        _controller.animateToPage(
          _controller.page!.floor() - 1,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return Container();
    }
    return SafeArea(
      child: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            children: pages
                .map((page) => _buildIntroductionPage(context, page))
                .toList(),
          ),
          if (_currentpage != pages.length - 1 &&
              introductionSettings.showSkipButton) ...[
            _buildSkipButton(context)
          ],
          _buildPageIndicator(context),
          if (introductionSettings.buttonMode! ==
              IntroductionScreenButtonMode.Text) ...[
            if (_currentpage == 0) ...[
              Align(alignment: Alignment.bottomLeft, child: Container())
            ] else ...[
              _buildPreviousPageButton(context)
            ],
            if (_currentpage == pages.length - 1 &&
                introductionSettings.showFinishButton!) ...[
              _buildStartAppButton(context),
            ] else ...[
              _buildNextPageButton(context),
            ],
          ] else if (introductionSettings.buttonMode! ==
              IntroductionScreenButtonMode.Icon) ...[
            _buildPageIconButtons(context),
          ],
        ],
      ),
    );
  }

  GestureDetector _buildIntroductionPage(
    BuildContext context,
    IntroductionPage page,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: _handleTapUp,
      onHorizontalDragUpdate: _handleHorizontalDrag,
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: Stack(
          children: [
            if (page.backgroundImage != null) ...[
              Positioned.fill(
                child: Image.asset(page.backgroundImage!, fit: BoxFit.cover),
              ),
            ],
            Column(
              crossAxisAlignment: introductionSettings.introductionTextAlign
                  .toCrossAxisAlignment(),
              children: <Widget>[
                if (introductionSettings.layoutStyle ==
                    IntroductionLayoutStyle.ImageTop) ...[
                  Expanded(
                    child: Center(
                      child: _buildCenterImage(page, context),
                    ),
                  ),
                ],
                Container(
                  constraints: BoxConstraints(
                    minHeight:
                        (Theme.of(context).textTheme.headline3?.fontSize ??
                                    16) *
                                2.8 +
                            50,
                  ),
                  child: _buildTitle(context, page),
                ),
                if (introductionSettings.layoutStyle ==
                    IntroductionLayoutStyle.ImageCenter) ...[
                  Expanded(
                    child: Center(
                      child: _buildCenterImage(page, context),
                    ),
                  ),
                ],
                Container(
                  constraints: BoxConstraints(
                    minHeight:
                        (Theme.of(context).textTheme.bodyText1?.fontSize ??
                                    16) *
                                5 +
                            100,
                  ),
                  child: _buildIntroductionDescription(context, page),
                ),
                if (introductionSettings.layoutStyle ==
                    IntroductionLayoutStyle.ImageBottom) ...[
                  Expanded(
                    child: Container(
                      child: _buildCenterImage(page, context),
                    ),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPageIconButtons(BuildContext context) {
    return SizedBox.expand(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (_currentpage != 0) ...[
            IconButton(
              iconSize: 60,
              icon: ShadowIcon(
                icon: Icon(
                  Icons.skip_previous,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 60,
                ),
                shadow: Colors.black45,
              ),
              onPressed: () {
                _controller.previousPage(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 10),
                );
                setState(() {
                  _currentpage = _currentpage - 1;
                });
              },
            )
          ] else ...[
            const SizedBox.shrink()
          ],
          IconButton(
            iconSize: 60,
            icon: ShadowIcon(
              icon: Icon(
                Icons.skip_next,
                color: Theme.of(context).colorScheme.secondary,
                size: 60,
              ),
              shadow: Colors.black45,
            ),
            onPressed: () {
              if (_controller.page! < pages.length - 1) {
                _controller.nextPage(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 10),
                );
              } else {
                _onComplete();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildCenterImage(IntroductionPage page, BuildContext context) {
    if (page.animation != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: page.animation,
      );
    } else if (page.image != null) {
      var package = '';
      var image = '';
      var images = page.image!.split(';');
      if (images.length > 1) {
        image = images[0];
        package = images[1];
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Image.asset(
            image,
            package: package,
            alignment: Alignment.topCenter,
            fit: BoxFit.contain,
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Image.asset(
          page.image!,
          alignment: Alignment.topCenter,
          fit: BoxFit.contain,
        ),
      );
    } else if (page.icon != null) {
      return Container(
        color: page.backgroundImage != null
            ? Colors.transparent
            : Theme.of(context).backgroundColor,
        padding: const EdgeInsets.all(20),
        child: Center(
          child:
              Icon(page.icon, color: Theme.of(context).primaryColor, size: 136),
        ),
      );
    }
    return Container();
  }

  Padding _buildNextPageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 10),
      child: Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          child: Text('Next', style: Theme.of(context).textTheme.subtitle1),
          onPressed: () {
            if (_controller.page!.toInt() < pages.length - 1) {
              _controller.animateToPage(
                _controller.page!.floor() + 1,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
              );
            } else {
              _onComplete();
            }
          },
        ),
      ),
    );
  }

  Padding _buildStartAppButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 10),
      child: Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          onPressed: _onComplete,
          child: Text(
            'Start',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Padding _buildPreviousPageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: TextButton(
          child: Text(
            'Previous',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: () {
            if (_controller.page!.toInt() > 0) {
              _controller.animateToPage(
                _controller.page!.floor() - 1,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    late Widget indicator;

    if (introductionSettings.introductionIndicatorMode == IndicatorMode.Dot) {
      indicator = DotsIndicator(
        color: Theme.of(context).backgroundColor,
        dotcolor: Theme.of(context).primaryColor,
        controller: _controller,
        itemCount: pages.length,
      );
    } else {
      indicator = DashIndicator(
        controller: _controller,
        selectedColor: Theme.of(context).primaryColor,
        color: Theme.of(context).colorScheme.secondary,
        itemCount: pages.length,
        onPageSelected: (index) {},
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 90,
        child: indicator,
      ),
    );
  }

  Widget _buildIntroductionDescription(
    BuildContext context,
    IntroductionPage page,
  ) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 40, right: 40),
        child: Material(
          color: Colors.transparent,
          child: Text(
            page.text ?? '',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: introductionSettings.introductionTextAlign,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, IntroductionPage page) {
    return IgnorePointer(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 50, right: 40, left: 40),
          child: Material(
            color: Colors.transparent,
            child: Text(
              page.title ?? '',
              style: Theme.of(context).textTheme.headline3,
              textAlign: introductionSettings.introductionTextAlign,
            ),
          ),
        ),
      ),
    );
  }

  Align _buildSkipButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: TextButton(
          onPressed: _onComplete,
          child: Text('Skip', style: Theme.of(context).textTheme.subtitle1),
        ),
      ),
    );
  }
}
