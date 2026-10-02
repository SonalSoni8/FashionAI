import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../wardrobe/providers/wardrobe_provider.dart';
import '../data/datasources/analytics_calculator_service.dart';
import '../domain/models/wardrobe_analytics_entity.dart';

final wardrobeAnalyticsProvider = Provider<WardrobeAnalyticsEntity>((ref) {
  final wardrobeState = ref.watch(wardrobeProvider);

  return AnalyticsCalculatorService.computeAnalytics(
    totalItemsCount: wardrobeState.items.length,
  );
});
