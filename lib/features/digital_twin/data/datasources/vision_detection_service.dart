import 'package:uuid/uuid.dart';

import '../../domain/models/digital_twin_entity.dart';
import '../../domain/models/image_quality_report.dart';
import '../../domain/models/pose_landmark_point.dart';

class VisionDetectionService {
  Future<ImageQualityReport> validateCaptureQuality(String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ImageQualityReport.optimal;
  }

  Future<DigitalTwinEntity> extractAttributesAndGenerateTwin({
    required String userId,
    required String frontImagePath,
    required String leftSideImagePath,
    required String rightSideImagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final landmarks = [
      const PoseLandmarkPoint(
          id: 11,
          name: 'leftShoulder',
          x: 0.35,
          y: 0.28,
          z: -0.05,
          visibility: 0.99),
      const PoseLandmarkPoint(
          id: 12,
          name: 'rightShoulder',
          x: 0.65,
          y: 0.28,
          z: -0.05,
          visibility: 0.99),
      const PoseLandmarkPoint(
          id: 23, name: 'leftHip', x: 0.38, y: 0.58, z: 0.02, visibility: 0.98),
      const PoseLandmarkPoint(
          id: 24, name: 'rightHip', x: 0.62, y: 0.58, z: 0.02, visibility: 0.98),
      const PoseLandmarkPoint(
          id: 25, name: 'leftKnee', x: 0.40, y: 0.78, z: 0.08, visibility: 0.96),
      const PoseLandmarkPoint(
          id: 26, name: 'rightKnee', x: 0.60, y: 0.78, z: 0.08, visibility: 0.96),
    ];

    final twinId = 'TWIN_${const Uuid().v4().substring(0, 8).toUpperCase()}';

    return DigitalTwinEntity(
      twinId: twinId,
      userId: userId,
      frontImagePath: frontImagePath,
      leftSideImagePath: leftSideImagePath,
      rightSideImagePath: rightSideImagePath,
      transparentSilhouettePath: frontImagePath,
      poseLandmarks: landmarks,
      heightCm: 180.0,
      shoulderWidthCm: 44.5,
      chestWidthCm: 94.0,
      waistWidthCm: 76.0,
      hipWidthCm: 98.0,
      armLengthCm: 63.0,
      legLengthCm: 89.0,
      bodyShape: 'Athletic V-Shape',
      skinToneName: 'Warm Olive Level 3',
      skinToneHex: '#D4A373',
      undertone: 'Golden Warm',
      seasonalPalette: 'Deep Autumn / Cool Winter',
      hairColourName: 'Dark Espresso',
      hairColourHex: '#1C1917',
      eyeColourName: 'Deep Charcoal / Hazel',
      eyeColourHex: '#292524',
      isDefaultMannequin: true,
      createdAt: DateTime.now(),
    );
  }
}
