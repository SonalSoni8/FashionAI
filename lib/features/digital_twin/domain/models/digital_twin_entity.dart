import 'package:flutter/foundation.dart';
import 'pose_landmark_point.dart';

@immutable
class DigitalTwinEntity {
  final String twinId; // Permanent Mannequin ID
  final String userId;
  final String frontImagePath;
  final String leftSideImagePath;
  final String rightSideImagePath;
  final String transparentSilhouettePath;
  final List<PoseLandmarkPoint> poseLandmarks;

  // Measurements (cm)
  final double heightCm;
  final double shoulderWidthCm;
  final double chestWidthCm;
  final double waistWidthCm;
  final double hipWidthCm;
  final double armLengthCm;
  final double legLengthCm;

  // Physical Attributes
  final String bodyShape; // Hourglass, Athletic V-Shape, Pear, Rectangle, etc.
  final String skinToneName;
  final String skinToneHex;
  final String undertone;
  final String seasonalPalette;
  final String hairColourName;
  final String hairColourHex;
  final String eyeColourName;
  final String eyeColourHex;

  final bool isDefaultMannequin;
  final DateTime createdAt;

  const DigitalTwinEntity({
    required this.twinId,
    required this.userId,
    required this.frontImagePath,
    required this.leftSideImagePath,
    required this.rightSideImagePath,
    required this.transparentSilhouettePath,
    required this.poseLandmarks,
    required this.heightCm,
    required this.shoulderWidthCm,
    required this.chestWidthCm,
    required this.waistWidthCm,
    required this.hipWidthCm,
    required this.armLengthCm,
    required this.legLengthCm,
    required this.bodyShape,
    required this.skinToneName,
    required this.skinToneHex,
    required this.undertone,
    required this.seasonalPalette,
    required this.hairColourName,
    required this.hairColourHex,
    required this.eyeColourName,
    required this.eyeColourHex,
    required this.isDefaultMannequin,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'twin_id': twinId,
      'user_id': userId,
      'front_image_path': frontImagePath,
      'left_side_image_path': leftSideImagePath,
      'right_side_image_path': rightSideImagePath,
      'transparent_silhouette_path': transparentSilhouettePath,
      'pose_landmarks': poseLandmarks.map((p) => p.toJson()).toList(),
      'height_cm': heightCm,
      'shoulder_width_cm': shoulderWidthCm,
      'chest_width_cm': chestWidthCm,
      'waist_width_cm': waistWidthCm,
      'hip_width_cm': hipWidthCm,
      'arm_length_cm': armLengthCm,
      'leg_length_cm': legLengthCm,
      'body_shape': bodyShape,
      'skin_tone_name': skinToneName,
      'skin_tone_hex': skinToneHex,
      'undertone': undertone,
      'seasonal_palette': seasonalPalette,
      'hair_colour_name': hairColourName,
      'hair_colour_hex': hairColourHex,
      'eye_colour_name': eyeColourName,
      'eye_colour_hex': eyeColourHex,
      'is_default_mannequin': isDefaultMannequin,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory DigitalTwinEntity.fromJson(Map<String, dynamic> json) {
    final rawLandmarks = json['pose_landmarks'] as List? ?? [];
    return DigitalTwinEntity(
      twinId: json['twin_id'] ?? '',
      userId: json['user_id'] ?? '',
      frontImagePath: json['front_image_path'] ?? '',
      leftSideImagePath: json['left_side_image_path'] ?? '',
      rightSideImagePath: json['right_side_image_path'] ?? '',
      transparentSilhouettePath: json['transparent_silhouette_path'] ?? '',
      poseLandmarks: rawLandmarks
          .map((e) => PoseLandmarkPoint.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 175.0,
      shoulderWidthCm: (json['shoulder_width_cm'] as num?)?.toDouble() ?? 43.0,
      chestWidthCm: (json['chest_width_cm'] as num?)?.toDouble() ?? 92.0,
      waistWidthCm: (json['waist_width_cm'] as num?)?.toDouble() ?? 74.0,
      hipWidthCm: (json['hip_width_cm'] as num?)?.toDouble() ?? 96.0,
      armLengthCm: (json['arm_length_cm'] as num?)?.toDouble() ?? 62.0,
      legLengthCm: (json['leg_length_cm'] as num?)?.toDouble() ?? 88.0,
      bodyShape: json['body_shape'] ?? 'Athletic V-Shape',
      skinToneName: json['skin_tone_name'] ?? 'Warm Olive Level 3',
      skinToneHex: json['skin_tone_hex'] ?? '#D4A373',
      undertone: json['undertone'] ?? 'Golden Warm',
      seasonalPalette: json['seasonal_palette'] ?? 'Deep Autumn / Cool Winter',
      hairColourName: json['hair_colour_name'] ?? 'Dark Espresso',
      hairColourHex: json['hair_colour_hex'] ?? '#1C1917',
      eyeColourName: json['eye_colour_name'] ?? 'Deep Charcoal / Hazel',
      eyeColourHex: json['eye_colour_hex'] ?? '#292524',
      isDefaultMannequin: json['is_default_mannequin'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
