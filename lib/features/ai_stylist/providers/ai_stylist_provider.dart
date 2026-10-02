import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colour_passport/providers/colour_passport_provider.dart';
import '../../digital_twin/providers/digital_twin_provider.dart';
import '../../wardrobe/providers/wardrobe_provider.dart';
import '../data/datasources/gemini_fashion_ai_service.dart';
import '../domain/models/chat_message_entity.dart';
import '../domain/models/stylist_context_payload.dart';

class AiStylistState {
  final List<ChatMessageEntity> messages;
  final bool isThinking;
  final StylistContextPayload contextPayload;

  const AiStylistState({
    required this.messages,
    this.isThinking = false,
    required this.contextPayload,
  });

  AiStylistState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isThinking,
    StylistContextPayload? contextPayload,
  }) {
    return AiStylistState(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
      contextPayload: contextPayload ?? this.contextPayload,
    );
  }
}

class AiStylistNotifier extends StateNotifier<AiStylistState> {
  final GeminiFashionAiService _service = GeminiFashionAiService();
  final Ref _ref;

  AiStylistNotifier(this._ref)
      : super(
          AiStylistState(
            messages: _initialGreetingMessages(),
            contextPayload: _buildContextPayload(_ref),
          ),
        );

  static StylistContextPayload _buildContextPayload(Ref ref) {
    final twinState = ref.read(digitalTwinProvider);
    final twin = twinState.activeTwin;
    final wardrobeState = ref.read(wardrobeProvider);
    final passport = ref.read(colourPassportProvider);

    return StylistContextPayload(
      userName: 'Alex Morgan',
      bodyShape: twin?.bodyShape ?? 'Athletic V-Shape',
      heightCm: twin?.heightCm ?? 180.0,
      wardrobeItemCount: wardrobeState.items.length,
      skinToneName: passport.skinToneName,
      seasonalPalette: passport.seasonPalette,
      weatherCondition: 'Clear Skies',
      temperature: '72°F',
      occasion: 'Office & Everyday Luxe',
      budgetTier: 'Quiet Luxury',
    );
  }

  static List<ChatMessageEntity> _initialGreetingMessages() {
    return [
      ChatMessageEntity(
        id: '1',
        text:
            "Good morning Alex. I have bound your **Aura Twin** (Athletic V-Shape), **42 Wardrobe Items**, **Deep Autumn Palette**, and today's **72°F Clear Weather**.\n\nHow can I style you today?",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessageEntity(
      id: DateTime.now().toIso8601String(),
      text: text,
      sender: ChatSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMsg];
    state = state.copyWith(messages: updatedMessages, isThinking: true);

    final currentPayload = _buildContextPayload(_ref);
    final aiMsg = await _service.queryStylist(
      prompt: text,
      contextPayload: currentPayload,
    );

    state = state.copyWith(
      messages: [...state.messages, aiMsg],
      isThinking: false,
      contextPayload: currentPayload,
    );
  }
}

final aiStylistProvider =
    StateNotifierProvider<AiStylistNotifier, AiStylistState>((ref) {
  return AiStylistNotifier(ref);
});
