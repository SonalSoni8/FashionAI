import 'package:flutter/foundation.dart';

@immutable
class AiLearningVector {
  final double fitWeight; // 0.0 to 1.0 (e.g. 0.94)
  final double colorWeight; // 0.0 to 1.0 (e.g. 0.98)
  final double brandWeight; // 0.0 to 1.0 (e.g. 0.82)
  final double priceVersatilityWeight; // 0.0 to 1.0 (e.g. 0.91)
  final int totalInteractionsLogged;
  final String learningModelStatus;

  const AiLearningVector({
    this.fitWeight = 0.94,
    this.colorWeight = 0.98,
    this.brandWeight = 0.82,
    this.priceVersatilityWeight = 0.91,
    this.totalInteractionsLogged = 1420,
    this.learningModelStatus = 'Active Real-Time Auto-Tuning',
  });
}
