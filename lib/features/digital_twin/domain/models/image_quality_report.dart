import 'package:flutter/foundation.dart';

@immutable
class ImageQualityReport {
  final bool isValid;
  final double lightingScore; // 0.0 to 1.0
  final double clarityScore;  // 0.0 to 1.0
  final double framingScore;  // 0.0 to 1.0
  final String feedbackMessage;

  const ImageQualityReport({
    required this.isValid,
    required this.lightingScore,
    required this.clarityScore,
    required this.framingScore,
    required this.feedbackMessage,
  });

  static const optimal = ImageQualityReport(
    isValid: true,
    lightingScore: 0.92,
    clarityScore: 0.95,
    framingScore: 0.98,
    feedbackMessage: '✓ Perfect lighting & full-body framing detected.',
  );
}
