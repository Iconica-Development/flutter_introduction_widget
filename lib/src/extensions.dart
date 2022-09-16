// ignore_for_file: prefer_mixin

import 'package:flutter/material.dart';

class NavigateWidgetMixin {
  void navigateFadeTo(
    BuildContext context,
    WidgetBuilder buildChild, {
    String? routeName,
    bool? opaque,
    Color? barrierColor,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: opaque ?? true,
        barrierColor: barrierColor,
        settings: RouteSettings(name: routeName),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondamination, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (BuildContext ctx, animation, __) => buildChild(ctx),
      ),
    );
  }

  void navigateFadeToReplace(
    BuildContext context,
    WidgetBuilder buildChild, {
    bool popRemaining = false,
  }) {
    if (popRemaining) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondamination, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (BuildContext ctx, animation, __) => buildChild(ctx),
      ),
    );
  }
}

abstract class NavigateWidget extends StatelessWidget with NavigateWidgetMixin {
  const NavigateWidget({super.key});
}

abstract class StatefulNavigateWidget extends StatefulWidget
    with NavigateWidgetMixin {
  const StatefulNavigateWidget({super.key});
}

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
