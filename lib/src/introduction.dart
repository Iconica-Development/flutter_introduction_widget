// ignore_for_file: constant_identifier_names, prefer_mixin

library introductionpages;

import 'dart:math' show max;
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/extensions.dart';
import 'introduction_page.dart';

extension AlignmentFromTextAlign on TextAlign {
  CrossAxisAlignment toCrossAxisAlignment() {
    switch (this) {
      case TextAlign.left:
        return CrossAxisAlignment.start;
      case TextAlign.right:
        return CrossAxisAlignment.end;
      case TextAlign.center:
        return CrossAxisAlignment.center;
      // ignore: no_default_cases
      default:
        return CrossAxisAlignment.end;
    }
  }
}

class Introduction extends StatefulWidget {
  Introduction({
    key,
    this.child,
    this.onComplete,
    this.pages,
    IntroductionSettings? introductionSettings,
    // ignore: prefer_asserts_with_message
  })  : assert(!(child == null && onComplete == null)),
        super(key: key) {
    this.introductionSettings = introductionSettings ?? IntroductionSettings();
  }
  final Widget? child;
  final List<IntroductionPage>? pages;
  final VoidCallback? onComplete;
  late final IntroductionSettings introductionSettings;

  @override
  // ignore: library_private_types_in_public_api
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> with NavigateWidgetMixin {
  static final _defaultPages = [
    IntroductionPage(
      title: 'Welkom bij de appshell',
      text: 'De appshell is door iconica gebouwd ter ondersteuning '
          ' van vlotte development van apps!',
      image: 'assets/images/shell.png;appshell',
      icon: Icons.access_time,
      backgroundImage: null,
    ),
    IntroductionPage(
      title: 'Volledig aanpasbaar',
      text: 'Door het grote aantal aan opties en optimaal gebruik '
          'van het flutter thema kan de appshell met weinig moeite '
          'op verschillende maatwerk situaties worden toegepast',
      icon: Icons.access_alarm,
      image: 'assets/images/versitile.png;appshell',
      backgroundImage: null,
    ),
    IntroductionPage(
      title: 'Configureren!',
      text: 'Dit zijn de standaard introductieschermen van de appshell.'
          ' Geef zelf introductieschermen mee voor optimale aanpassing'
          ' aan je maatwerk app!',
      icon: Icons.account_circle,
      image: 'assets/images/config.png;appshell',
      backgroundImage: null,
    ),
  ];

  List<IntroductionPage> pages = [];
  int _currentpage = 0;
  final PageController _controller = PageController();
  late TextAlign textAlign;

  @override
  void initState() {
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
          pages = _defaultPages;
        }
        widget.introductionSettings.buttonMode =
            widget.introductionSettings.buttonMode;
        widget.introductionSettings.showSkipButton =
            widget.introductionSettings.showSkipButton;
        widget.introductionSettings.showFinishButton =
            widget.introductionSettings.showFinishButton ?? true;
        widget.introductionSettings.layoutStyle =
            widget.introductionSettings.layoutStyle;
        textAlign = [].contains(widget.introductionSettings.layoutStyle)
            ? TextAlign.center
            : TextAlign.left;
      });
    });
  }

  Future<void> _onComplete() async {
    widget.onComplete?.call();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.introductionSettings.introductionTapEnabled ?? false) {
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
              widget.introductionSettings.showSkipButton) ...[
            _buildSkipButton(context)
          ],
          _buildPageIndicator(context),
          if (widget.introductionSettings.buttonMode! ==
              IntroductionScreenButtonMode.Text) ...[
            if (_currentpage == 0) ...[
              Align(alignment: Alignment.bottomLeft, child: Container())
            ] else ...[
              _buildPreviousPageButton(context)
            ],
            if (_currentpage == pages.length - 1 &&
                widget.introductionSettings.showFinishButton!) ...[
              _buildStartAppButton(context),
            ] else ...[
              _buildNextPageButton(context),
            ],
          ] else if (widget.introductionSettings.buttonMode! ==
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
              crossAxisAlignment: widget
                  .introductionSettings.introductionTextAlign
                  .toCrossAxisAlignment(),
              children: <Widget>[
                if (widget.introductionSettings.layoutStyle ==
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
                if (widget.introductionSettings.layoutStyle ==
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
                if (widget.introductionSettings.layoutStyle ==
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

    if (widget.introductionSettings.introductionIndicatorMode ==
        IndicatorMode.Dot) {
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
            textAlign: widget.introductionSettings.introductionTextAlign,
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
              textAlign: widget.introductionSettings.introductionTextAlign,
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

class DashIndicator extends AnimatedWidget {
  const DashIndicator({
    required this.controller,
    required this.selectedColor,
    required this.itemCount,
    required this.onPageSelected,
    this.color = Colors.white,
    super.key,
  }) : super(listenable: controller);
  final PageController controller;
  final Color color;
  final Color selectedColor;
  final int itemCount;
  final Function(int) onPageSelected;

  @override
  Widget build(BuildContext context) {
    var index = (controller.page ?? controller.initialPage).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < itemCount; i++) ...[
          _buildDash(index: i, selected: index == i),
        ],
      ],
    );
  }

  Widget _buildDash({required int index, required bool selected}) {
    return SizedBox(
      width: 20,
      child: Center(
        child: Material(
          color: selected ? color : color.withAlpha(125),
          type: MaterialType.card,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
            ),
            width: 16,
            height: 5,
            child: InkWell(
              onTap: () => onPageSelected.call(index),
            ),
          ),
        ),
      ),
    );
  }
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    required this.controller,
    this.color = Colors.white,
    this.dotcolor,
    this.itemCount,
    this.onPageSelected,
    super.key,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final Color? dotcolor;
  final PageController controller;

  /// The number of items managed by the PageController
  final int? itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int>? onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 4.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 12.0;

  Widget _buildDot(int index) {
    var selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 -
            ((controller.page ?? controller.initialPage).round() - index).abs(),
      ),
    );
    var zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;

    return SizedBox(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: ((controller.page ?? controller.initialPage).round()) == index
              ? color
              : color.withAlpha(125),
          type: MaterialType.circle,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: dotcolor!),
            ),
            width: _kDotSize * 2 * zoom,
            height: _kDotSize * 2 * zoom,
            child: InkWell(
              onTap: () => onPageSelected!.call(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount!, _buildDot),
    );
  }
}

// wrapper class to enable old API from shadow
// Icon with new DecoratedIcon package
class ShadowIcon extends StatelessWidget {
  const ShadowIcon({
    required this.icon,
    required this.shadow,
    super.key,
  });
  final Icon icon;
  final Color shadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedIcon(
      icon.icon!,
      color: icon.color,
      size: icon.size,
      semanticLabel: icon.semanticLabel,
      textDirection: icon.textDirection,
      shadows: [BoxShadow(color: shadow, blurRadius: 5)],
    );
  }
}
