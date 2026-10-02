import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/shopping_advisor_ai_engine.dart';
import '../domain/models/shopping_item_analysis.dart';

class ShoppingAdvisorState {
  final ShoppingItemAnalysis? currentAnalysis;
  final bool isAnalyzing;
  final String? inputQuery;
  final String activeSource; // 'Link', 'Screenshot', 'Photo'

  const ShoppingAdvisorState({
    this.currentAnalysis,
    this.isAnalyzing = false,
    this.inputQuery,
    this.activeSource = 'Link',
  });

  ShoppingAdvisorState copyWith({
    ShoppingItemAnalysis? currentAnalysis,
    bool? isAnalyzing,
    String? inputQuery,
    String? activeSource,
  }) {
    return ShoppingAdvisorState(
      currentAnalysis: currentAnalysis ?? this.currentAnalysis,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      inputQuery: inputQuery ?? this.inputQuery,
      activeSource: activeSource ?? this.activeSource,
    );
  }
}

class ShoppingAdvisorNotifier extends StateNotifier<ShoppingAdvisorState> {
  final ShoppingAdvisorAiEngine _engine = ShoppingAdvisorAiEngine();

  ShoppingAdvisorNotifier() : super(const ShoppingAdvisorState());

  Future<void> analyzeProduct({
    required String queryOrUrl,
    required String source,
  }) async {
    state = state.copyWith(
      isAnalyzing: true,
      inputQuery: queryOrUrl,
      activeSource: source,
    );

    final analysis = await _engine.analyzeItem(
      queryOrUrl: queryOrUrl,
      source: source,
    );

    state = state.copyWith(
      currentAnalysis: analysis,
      isAnalyzing: false,
    );
  }
}

final shoppingAdvisorProvider =
    StateNotifierProvider<ShoppingAdvisorNotifier, ShoppingAdvisorState>(
        (ref) {
  return ShoppingAdvisorNotifier();
});
