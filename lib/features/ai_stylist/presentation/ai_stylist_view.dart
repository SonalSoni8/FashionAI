import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/models/chat_message_entity.dart';
import '../domain/models/outfit_recommendation_card.dart';
import '../providers/ai_stylist_provider.dart';

class AiStylistView extends ConsumerStatefulWidget {
  const AiStylistView({super.key});

  @override
  ConsumerState<AiStylistView> createState() => _AiStylistViewState();
}

class _AiStylistViewState extends ConsumerState<AiStylistView> {
  final _controller = TextEditingController();

  final List<String> _quickPrompts = [
    "What should I wear today?",
    "Create 10 office outfits",
    "Create wedding outfits",
    "Which colour suits me?",
    "Rate this outfit",
    "Generate packing list",
    "Create airport look",
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    _controller.clear();
    ref.read(aiStylistProvider.notifier).sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiStylistProvider);
    final contextPayload = chatState.contextPayload;

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: AuraColors.auraGradientPrimary,
              ),
              child: const Icon(
                Icons.sparkles,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Aura Conversational Stylist",
              style: AuraTypography.title(isDark: true).copyWith(fontSize: 16),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Active Context Badge Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.04),
                border: Border.all(color: AuraColors.glassBorderDark),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildContextChip(
                      icon: Icons.accessibility_new_rounded,
                      label: "Twin: ${contextPayload.bodyShape}",
                      color: AuraColors.auraViolet,
                    ),
                    const SizedBox(width: 8),
                    _buildContextChip(
                      icon: Icons.checkroom_rounded,
                      label: "${contextPayload.wardrobeItemCount} Wardrobe Items",
                      color: AuraColors.auraCyan,
                    ),
                    const SizedBox(width: 8),
                    _buildContextChip(
                      icon: Icons.palette_rounded,
                      label: contextPayload.seasonalPalette,
                      color: AuraColors.auraRose,
                    ),
                    const SizedBox(width: 8),
                    _buildContextChip(
                      icon: Icons.wb_sunny_rounded,
                      label:
                          "${contextPayload.temperature} ${contextPayload.weatherCondition}",
                      color: AuraColors.auraAmber,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Message Chat History Stream
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatState.messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            // Thinking State Indicator
            if (chatState.isThinking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AuraColors.auraViolet,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Aura AI is synthesizing your Twin, Wardrobe & Color Palette...",
                      style: AuraTypography.caption(isDark: true).copyWith(
                        color: AuraColors.auraViolet,
                      ),
                    ),
                  ],
                ),
              ),

            // Quick Prompt Action Chips Bar
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _quickPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = _quickPrompts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(prompt),
                      onPressed: () => _send(prompt),
                      backgroundColor: Colors.white.withOpacity(0.06),
                      side: const BorderSide(color: AuraColors.glassBorderDark),
                      labelStyle: AuraTypography.caption(isDark: true).copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Input TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _send,
                      style: AuraTypography.bodyMedium(isDark: true),
                      decoration: InputDecoration(
                        hintText: 'Ask Aura Stylist anything...',
                        hintStyle: AuraTypography.caption(isDark: true),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AuraColors.glassBorderDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AuraColors.auraViolet),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _send(_controller.text),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AuraColors.auraGradientPrimary,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: AuraTypography.caption(isDark: true).copyWith(
            fontSize: 10,
            color: Colors.white87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessageEntity msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAlignment.end : CrossAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AuraColors.auraGradientPrimary,
                  ),
                  child: const Icon(
                    Icons.sparkles,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
              ],

              Flexible(
                child: GlassCard(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(16),
                  isGlowing: !isUser,
                  glowColor: AuraColors.auraViolet,
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        msg.text,
                        style: AuraTypography.bodyMedium(isDark: true).copyWith(
                          color: isUser ? Colors.white : Colors.white90,
                          height: 1.4,
                        ),
                      ),

                      // Outfit Recommendation Cards Attachment
                      if (msg.outfitCards != null &&
                          msg.outfitCards!.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Column(
                          children: msg.outfitCards!
                              .map((card) => _buildOutfitCard(card))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (isUser) const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitCard(OutfitRecommendationCard card) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: AuraColors.auraViolet.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.title,
                style: AuraTypography.title(isDark: true).copyWith(fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AuraColors.auraEmerald.withOpacity(0.2),
                ),
                child: Text(
                  card.matchPercentage,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AuraColors.auraEmerald,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            card.description,
            style: AuraTypography.caption(isDark: true),
          ),
          const SizedBox(height: 10),

          // Outlined Item List
          if (card.outerwearItem.isNotEmpty)
            _buildItemRow("Outerwear", card.outerwearItem),
          _buildItemRow("Top", card.topItem),
          _buildItemRow("Bottom", card.bottomItem),
          _buildItemRow("Footwear", card.footwearItem),

          const SizedBox(height: 12),

          // Wear in Studio Action Trigger
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AuraColors.auraViolet,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 38),
            ),
            icon: const Icon(Icons.checkroom_rounded, size: 16, color: Colors.white),
            label: Text(
              "Wear in Virtual Studio",
              style: AuraTypography.caption(isDark: true).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              context.push(AppRoutes.virtualTryOn);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: AuraTypography.caption(isDark: true).copyWith(
              color: AuraColors.textMutedDark,
              fontSize: 11,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AuraTypography.caption(isDark: true).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
