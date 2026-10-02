import 'package:flutter/foundation.dart';

enum TryOnLayerCategory { top, bottom, footwear, outerwear, accessory }

@immutable
class TryOnLayerItem {
  final String garmentId;
  final String name;
  final TryOnLayerCategory category;
  final String primaryColorHex;
  final int zIndex; // Outerwear: 4, Top: 3, Bottom: 2, Footwear: 1

  // Computed 3D Landmark Transformations
  final double scaleX;
  final double scaleY;
  final double offsetX;
  final double offsetY;
  final double rotationDegrees;

  const TryOnLayerItem({
    required this.garmentId,
    required this.name,
    required this.category,
    required this.primaryColorHex,
    required this.zIndex,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.rotationDegrees = 0.0,
  });

  TryOnLayerItem copyWith({
    String? garmentId,
    String? name,
    TryOnLayerCategory? category,
    String? primaryColorHex,
    int? zIndex,
    double? scaleX,
    double? scaleY,
    double? offsetX,
    double? offsetY,
    double? rotationDegrees,
  }) {
    return TryOnLayerItem(
      garmentId: garmentId ?? this.garmentId,
      name: name ?? this.name,
      category: category ?? this.category,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      zIndex: zIndex ?? this.zIndex,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
    );
  }
}
