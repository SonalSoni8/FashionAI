import 'package:flutter/foundation.dart';

@immutable
class ColourDistributionItem {
  final String name;
  final String hex;
  final double percentage; // 0.0 to 100.0%
  final int itemCount;

  const ColourDistributionItem({
    required this.name,
    required this.hex,
    required this.percentage,
    required this.itemCount,
  });
}
