import 'package:flutter/foundation.dart';

enum OccasionType {
  today,
  tomorrow,
  office,
  wedding,
  travel,
  gym,
  college,
  festival
}

@immutable
class CalendarOutfitSlot {
  final String id;
  final OccasionType occasionType;
  final String title;
  final String dateLabel;
  final String temperature;
  final String weatherCondition;
  final String topItem;
  final String bottomItem;
  final String outerwearItem;
  final String footwearItem;
  final String matchScore;
  final bool hasReminder;
  final String reminderTime;

  const CalendarOutfitSlot({
    required this.id,
    required this.occasionType,
    required this.title,
    required this.dateLabel,
    required this.temperature,
    required this.weatherCondition,
    required this.topItem,
    required this.bottomItem,
    this.outerwearItem = '',
    required this.footwearItem,
    required this.matchScore,
    this.hasReminder = true,
    this.reminderTime = '7:30 AM',
  });

  CalendarOutfitSlot copyWith({
    String? id,
    OccasionType? occasionType,
    String? title,
    String? dateLabel,
    String? temperature,
    String? weatherCondition,
    String? topItem,
    String? bottomItem,
    String? outerwearItem,
    String? footwearItem,
    String? matchScore,
    bool? hasReminder,
    String? reminderTime,
  }) {
    return CalendarOutfitSlot(
      id: id ?? this.id,
      occasionType: occasionType ?? this.occasionType,
      title: title ?? this.title,
      dateLabel: dateLabel ?? this.dateLabel,
      temperature: temperature ?? this.temperature,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      topItem: topItem ?? this.topItem,
      bottomItem: bottomItem ?? this.bottomItem,
      outerwearItem: outerwearItem ?? this.outerwearItem,
      footwearItem: footwearItem ?? this.footwearItem,
      matchScore: matchScore ?? this.matchScore,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
