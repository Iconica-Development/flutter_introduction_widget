// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    this.background,
    required this.child,
    Key? key,
  }) : super(key: key);

  final BoxDecoration? background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var background = this.background ??
        BoxDecoration(
          color: theme.colorScheme.background,
        );
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: background,
      child: child,
    );
  }
}
