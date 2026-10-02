import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../digital_twin/providers/digital_twin_provider.dart';
import '../data/datasources/colour_analysis_engine.dart';
import '../domain/models/colour_passport_entity.dart';

final colourPassportProvider = Provider<ColourPassportEntity>((ref) {
  final twinState = ref.watch(digitalTwinProvider);
  final twin = twinState.activeTwin;

  return ColourAnalysisEngine.generatePassportFromTwin(
    skinToneName: twin?.skinToneName ?? 'Warm Olive Level 3',
    skinToneHex: twin?.skinToneHex ?? '#D4A373',
    undertone: twin?.undertone ?? 'Golden Warm Olive',
    seasonalPalette: twin?.seasonalPalette ?? 'Deep Autumn / Cool Winter',
  );
});
