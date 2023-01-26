// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    this.background,
    required this.child,
    this.backgroundImage,
    Key? key,
  }) : super(key: key);

  final Decoration? background;
  final Widget child;
  final ImageProvider? backgroundImage;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var background = this.background ??
        BoxDecoration(
          color: theme.backgroundColor,
        );
    var size = MediaQuery.of(context).size;
    var backgroundImage = this.backgroundImage;
    if (backgroundImage != null) {
      return Container(
        width: size.width,
        height: size.height,
        decoration: background,
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
      return Container(
        width: size.width,
        height: size.height,
        decoration: background,
        child: child,
      );
    }
  }
}
