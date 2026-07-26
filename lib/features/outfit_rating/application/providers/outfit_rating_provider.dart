import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/ai_provider_factory.dart';
import '../../domain/models/outfit_rating_entity.dart';
import '../../domain/repositories/i_outfit_rating_repository.dart';
import '../../data/repositories/outfit_rating_repository.dart';

final outfitRatingRepositoryProvider = Provider<IOutfitRatingRepository>((ref) {
  final aiService = ref.watch(aiStylistServiceProvider);
  return OutfitRatingRepository(aiService);
});

class OutfitRatingState {
  final OutfitRatingEntity? rating;
  final bool isAnalyzing;
  final String? errorMessage;

  const OutfitRatingState({
    this.rating,
    this.isAnalyzing = false,
    this.errorMessage,
  });

  OutfitRatingState copyWith({
    OutfitRatingEntity? rating,
    bool? isAnalyzing,
    String? errorMessage,
  }) {
    return OutfitRatingState(
      rating: rating ?? this.rating,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      errorMessage: errorMessage,
    );
  }
}

class OutfitRatingControllerNotifier extends StateNotifier<OutfitRatingState> {
  final IOutfitRatingRepository _repository;

  OutfitRatingControllerNotifier(this._repository) : super(const OutfitRatingState());

  Future<void> analyzePhoto(String imagePath, {String? occasion}) async {
    state = state.copyWith(isAnalyzing: true, errorMessage: null);
    final result = await _repository.analyzeOutfitPhoto(
      imagePath: imagePath,
      occasion: occasion,
    );

    result.fold(
      onSuccess: (rating) {
        state = OutfitRatingState(rating: rating, isAnalyzing: false);
      },
      onFailure: (failure) {
        state = state.copyWith(isAnalyzing: false, errorMessage: failure.message);
      },
    );
  }
}

final outfitRatingControllerProvider =
    StateNotifierProvider<OutfitRatingControllerNotifier, OutfitRatingState>((ref) {
  return OutfitRatingControllerNotifier(ref.watch(outfitRatingRepositoryProvider));
});
