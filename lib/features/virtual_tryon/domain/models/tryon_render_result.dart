import 'package:flutter/foundation.dart';

enum RenderEngineMode { landmarkMesh, cloudDiffusion, arMesh }

@immutable
class TryOnRenderResult {
  final String renderId;
  final RenderEngineMode engineMode;
  final String renderOutputUrl;
  final double outfitHarmonyScore; // 0.0 to 100.0%
  final String styleFeedback;
  final bool isCompleted;

  const TryOnRenderResult({
    required this.renderId,
    required this.engineMode,
    required this.renderOutputUrl,
    required this.outfitHarmonyScore,
    required this.styleFeedback,
    required this.isCompleted,
  });
}
