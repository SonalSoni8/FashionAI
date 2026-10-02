import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/aura_dna_engine.dart';
import '../domain/models/aura_dna_entity.dart';

final auraDnaProvider = Provider<AuraDnaEntity>((ref) {
  return AuraDnaEngine.synthesizeGenome();
});
