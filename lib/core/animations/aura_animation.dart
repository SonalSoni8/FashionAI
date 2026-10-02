import 'package:flutter/material.dart';

class AuraAnimation {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve springCurve = Curves.elasticOut;

  static Widget fadeSlideIn({
    required Widget child,
    required Animation<double> animation,
    Offset beginOffset = const Offset(0.0, 0.08),
  }) {
    final slideIn = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: defaultCurve));

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: slideIn, child: child),
    );
  }
}
