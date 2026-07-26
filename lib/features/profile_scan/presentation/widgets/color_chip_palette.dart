import 'package:flutter/material.dart';
import '../../../../core/theme/aura_colors.dart';
import '../../../../core/theme/aura_typography.dart';

class ColorChipPalette extends StatelessWidget {
  final String title;
  final List<String> hexColors;
  final bool isNegative;

  const ColorChipPalette({
    super.key,
    required this.title,
    required this.hexColors,
    this.isNegative = false,
  });

  Color _parseHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAlignment.start,
      children: [
        Text(
          title,
          style: AuraTypography.title(isDark: true).copyWith(
            color: isNegative ? AuraColors.auraRose : AuraColors.auraEmerald,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: hexColors.map((hex) {
            final color = _parseHex(hex);
            return Expanded(
              child: Container(
                height: 54,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: isNegative
                    ? const Center(
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
