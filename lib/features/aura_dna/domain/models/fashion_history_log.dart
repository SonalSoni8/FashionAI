import 'package:flutter/foundation.dart';

@immutable
class FashionHistoryLog {
  final String id;
  final String eventType; // 'Outfit Worn', 'Shopping Decision'
  final String title;
  final String description;
  final String ratingOrVerdict;
  final DateTime timestamp;

  const FashionHistoryLog({
    required this.id,
    required this.eventType,
    required this.title,
    required this.description,
    required this.ratingOrVerdict,
    required this.timestamp,
  });
}
