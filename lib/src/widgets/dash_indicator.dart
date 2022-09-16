import 'package:flutter/material.dart';

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
