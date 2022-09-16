import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';

/// wrapper class to enable old API from shadow
/// Icon with new DecoratedIcon package
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
