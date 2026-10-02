import 'dart:math';
import '../../digital_twin/domain/models/pose_landmark_point.dart';
import '../models/tryon_layer_item.dart';

class ComputeLandmarkTransformUseCase {
  TryOnLayerItem computeLayerTransform({
    required TryOnLayerItem layer,
    required List<PoseLandmarkPoint> poseLandmarks,
  }) {
    if (poseLandmarks.isEmpty) return layer;

    // Find key landmarks
    PoseLandmarkPoint? leftShoulder = _findLandmark(poseLandmarks, 11);
    PoseLandmarkPoint? rightShoulder = _findLandmark(poseLandmarks, 12);
    PoseLandmarkPoint? leftHip = _findLandmark(poseLandmarks, 23);
    PoseLandmarkPoint? rightHip = _findLandmark(poseLandmarks, 24);

    leftShoulder ??= const PoseLandmarkPoint(id: 11, name: 'leftShoulder', x: 0.35, y: 0.28, z: 0, visibility: 1);
    rightShoulder ??= const PoseLandmarkPoint(id: 12, name: 'rightShoulder', x: 0.65, y: 0.28, z: 0, visibility: 1);
    leftHip ??= const PoseLandmarkPoint(id: 23, name: 'leftHip', x: 0.38, y: 0.58, z: 0, visibility: 1);
    rightHip ??= const PoseLandmarkPoint(id: 24, name: 'rightHip', x: 0.62, y: 0.58, z: 0, visibility: 1);

    // Calculate shoulder width and rotation angle
    final dx = rightShoulder.x - leftShoulder.x;
    final dy = rightShoulder.y - leftShoulder.y;
    final shoulderWidth = sqrt(dx * dx + dy * dy);
    final angleRad = atan2(dy, dx);
    final angleDeg = angleRad * (180 / pi);

    double scaleX = 1.0;
    double scaleY = 1.0;
    double offsetX = 0.0;
    double offsetY = 0.0;

    switch (layer.category) {
      case TryOnLayerCategory.top:
      case TryOnLayerCategory.outerwear:
        scaleX = shoulderWidth * 2.8;
        scaleY = (leftHip.y - leftShoulder.y) * 2.2;
        offsetX = (leftShoulder.x + rightShoulder.x) / 2.0 - 0.5;
        offsetY = (leftShoulder.y + leftHip.y) / 2.0 - 0.45;
        break;

      case TryOnLayerCategory.bottom:
        final hipWidth = sqrt(pow(rightHip.x - leftHip.x, 2) + pow(rightHip.y - leftHip.y, 2));
        scaleX = hipWidth * 2.6;
        scaleY = (0.95 - leftHip.y) * 2.0;
        offsetX = (leftHip.x + rightHip.x) / 2.0 - 0.5;
        offsetY = leftHip.y - 0.25;
        break;

      case TryOnLayerCategory.footwear:
        scaleX = 1.1;
        scaleY = 0.8;
        offsetX = 0.0;
        offsetY = 0.38;
        break;

      case TryOnLayerCategory.accessory:
        scaleX = 1.0;
        scaleY = 1.0;
        offsetX = 0.0;
        offsetY = -0.3;
        break;
    }

    return layer.copyWith(
      scaleX: scaleX,
      scaleY: scaleY,
      offsetX: offsetX,
      offsetY: offsetY,
      rotationDegrees: angleDeg,
    );
  }

  PoseLandmarkPoint? _findLandmark(List<PoseLandmarkPoint> points, int id) {
    try {
      return points.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
