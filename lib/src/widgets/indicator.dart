// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_introduction_widget/src/introduction.dart';

import '../config/introduction.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    required this.mode,
    required this.controller,
    required this.count,
    required this.index,
    required this.indicatorBuilder,
    Key? key,
  })  : assert(
          !(mode == IndicatorMode.custom && indicatorBuilder == null),
          "When a custom indicator is used the indicatorBuilder must be provided",
        ),
        super(key: key);

  final IndicatorMode mode;
  final PageController controller;
  final Widget Function(
    BuildContext,
    PageController,
    int,
    int,
  )? indicatorBuilder;
  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (mode) {
      case IndicatorMode.custom:
        return indicatorBuilder!.call(context, controller, index, count);
      case IndicatorMode.dot:
        return DotsIndicator(
          controller: controller,
          color: theme.colorScheme.primary,
          dotcolor: theme.colorScheme.secondary,
          itemCount: count,
          onPageSelected: (int page) {
            controller.animateToPage(
              page,
              duration: kAnimationDuration,
              curve: Curves.easeInOut,
            );
          },
        );
      case IndicatorMode.dash:
        return DashIndicator(
          controller: controller,
          selectedColor: theme.colorScheme.primary,
          itemCount: count,
          onPageSelected: (int page) {
            controller.animateToPage(
              page,
              duration: kAnimationDuration,
              curve: Curves.easeInOut,
            );
          },
        );
    }
  }
}

class DashIndicator extends AnimatedWidget {
  final PageController controller;
  final Color color;
  final Color selectedColor;
  final int itemCount;
  final Function(int) onPageSelected;
  const DashIndicator(
      {required this.controller,
      this.color = Colors.white,
      required this.selectedColor,
      required this.itemCount,
      required this.onPageSelected,
      Key? key})
      : super(listenable: controller, key: key);

  int _getPage() {
    try {
      return controller.page?.round() ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = _getPage();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < itemCount; i++) ...[
          buildDash(i, index == i),
        ],
      ],
    );
  }

  Widget buildDash(int index, bool selected) {
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
    this.color = Colors.white,
    required this.controller,
    this.dotcolor = Colors.green,
    this.itemCount,
    this.onPageSelected,
    Key? key,
  }) : super(
          listenable: controller,
          key: key,
        );

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
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 -
            ((controller.page ?? controller.initialPage).round() - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;

    return SizedBox(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: (((controller.page ?? controller.initialPage).round()) == index
              ? color
              : color.withAlpha(125)),
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
