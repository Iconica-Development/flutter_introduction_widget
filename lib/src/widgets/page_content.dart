// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

import '../config/introduction.dart';

class IntroductionPageContent extends StatelessWidget {
  const IntroductionPageContent({
    required this.title,
    required this.text,
    required this.graphic,
    required this.layoutStyle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget? title;
  final Widget? text;
  final Widget? graphic;
  final IntroductionLayoutStyle layoutStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          if (graphic != null &&
              layoutStyle == IntroductionLayoutStyle.imageTop)
            graphic!,
          if (title != null) title!,
          if (graphic != null &&
              layoutStyle == IntroductionLayoutStyle.imageCenter)
            graphic!,
          if (text != null) text!,
          if (graphic != null &&
              layoutStyle == IntroductionLayoutStyle.imageBottom)
            graphic!,
        ],
      ),
    );
  }
}
