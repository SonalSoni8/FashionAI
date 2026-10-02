import 'package:flutter/material.dart';

import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';

enum AuraButtonStyle { primary, secondary, glassOutline }

class AuraButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AuraButtonStyle style;
  final double? height;
  final double? width;

  const AuraButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.style = AuraButtonStyle.primary,
    this.height = 54.0,
    this.width,
  });

  @override
  State<AuraButton> createState() => _AuraButtonState();
}

class _AuraButtonState extends State<AuraButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Decoration decoration;
    Color textColor = Colors.white;

    switch (widget.style) {
      case AuraButtonStyle.primary:
        decoration = BoxDecoration(
          gradient: AuraColors.auraGradientPrimary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AuraColors.auraViolet.withOpacity(_isHovered ? 0.5 : 0.3),
              blurRadius: _isHovered ? 20 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
        break;

      case AuraButtonStyle.secondary:
        decoration = BoxDecoration(
          color: AuraColors.surfaceDarkElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AuraColors.glassBorderDark),
        );
        textColor = AuraColors.textPrimaryDark;
        break;

      case AuraButtonStyle.glassOutline:
        decoration = BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? AuraColors.auraViolet : AuraColors.glassBorderDark,
          ),
        );
        textColor = Colors.white;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: decoration,
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: textColor,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: textColor, size: 20),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.text,
                        style: AuraTypography.labelButton(isDark: true).copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
