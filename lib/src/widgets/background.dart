import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    required this.child,
    this.backgroundImage,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final ImageProvider? backgroundImage;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var backgroundImage = this.backgroundImage;
    if (backgroundImage != null) {
      return Material(
        color: theme.backgroundColor,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: backgroundImage,
            ),
          ),
          child: child,
        ),
      );
    } else {
      return Material(
        color: theme.backgroundColor,
        child: child,
      );
    }
  }
}
