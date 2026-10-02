import 'package:flutter/foundation.dart';

@immutable
class PoseLandmarkPoint {
  final int id;
  final String name;
  final double x;
  final double y;
  final double z;
  final double visibility;

  const PoseLandmarkPoint({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'x': x,
      'y': y,
      'z': z,
      'visibility': visibility,
    };
  }

  factory PoseLandmarkPoint.fromJson(Map<String, dynamic> json) {
    return PoseLandmarkPoint(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      z: (json['z'] as num?)?.toDouble() ?? 0.0,
      visibility: (json['visibility'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
