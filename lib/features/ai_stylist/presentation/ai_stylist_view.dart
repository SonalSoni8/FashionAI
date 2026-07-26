import 'package:flutter/material.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/services/gemini_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AiStylistView extends StatefulWidget {
  const AiStylistView({super.key});

  @override
  State<AiStylistView> createState() => _AiStylistViewState();
}

class _AiStylistViewState extends State<AiStylistView> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _quickPrompts = [
    "What should I wear for an interview?",
    "Which glasses fit my face shape?",
    "Can I wear beige for a summer wedding?",
    "What colors elevate dark olive skin?",
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text:
            "Hello Alex. I am Aura AI, your personal personal stylist. Ask me anything about outfits, skin tone pairings, or event dress codes.",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage([String? customText]) async {
    final query = customText ?? _messageController.text.trim();
    if (query.isEmpty) return;

    if (customText == null) _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: query,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    final reply = await _geminiService.askStylist(query: query);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: reply,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AuraColors.auraEmerald,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Aura AI Stylist",
              style: AuraTypography.title(isDark: true),
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
            // Chat Message List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment:
                          msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: msg.isUser
                              ? AuraColors.auraGradientPrimary
                              : null,
                          color: msg.isUser
                              ? null
                              : AuraColors.surfaceDarkElevated,
                          border: msg.isUser
                              ? null
                              : Border.all(color: AuraColors.glassBorderDark),
                        ),
                        child: Text(
                          msg.text,
                          style: AuraTypography.bodyLarge(isDark: true).copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AuraColors.auraViolet,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Aura AI is reasoning...",
                      style: AuraTypography.caption(isDark: true),
                    ),
                  ],
                ),
              ),

            // Quick Prompt Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _quickPrompts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(_quickPrompts[index]),
                      labelStyle: AuraTypography.caption(isDark: true).copyWith(
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.06),
                      side: const BorderSide(color: AuraColors.glassBorderDark),
                      onPressed: () => _sendMessage(_quickPrompts[index]),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Bottom Input Field
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: AuraTypography.bodyLarge(isDark: true).copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Ask about outfits, fits, colors...",
                        hintStyle: AuraTypography.bodyMedium(isDark: true),
                        filled: true,
                        fillColor: AuraColors.surfaceDarkElevated,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AuraColors.glassBorderDark),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (val) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _sendMessage(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AuraColors.auraGradientPrimary,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
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
}
