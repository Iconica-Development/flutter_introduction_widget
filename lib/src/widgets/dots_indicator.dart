import 'dart:math';

import 'package:flutter/material.dart';

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
