import 'package:flutter/material.dart';

@immutable
class IntroductionPage {
  const IntroductionPage({
    this.title,
    this.text,
    this.image,
    this.content,
  });

  final Widget? title;
  final Widget? text;
  final Widget? image;
  final Widget? content;
}
