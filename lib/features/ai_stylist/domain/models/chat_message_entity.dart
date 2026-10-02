import 'package:flutter/foundation.dart';
import 'outfit_recommendation_card.dart';

enum ChatSender { user, aiStylist }

@immutable
class ChatMessageEntity {
  final String id;
  final String text;
  final ChatSender sender;
  final DateTime timestamp;
  final List<OutfitRecommendationCard>? outfitCards;

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.outfitCards,
  });

  bool get isUser => sender == ChatSender.user;
  bool get isAi => sender == ChatSender.aiStylist;
}
