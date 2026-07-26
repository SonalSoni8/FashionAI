import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';

enum MorphingButtonStyle { primaryGradient, glassOutline, subtleDark }

class MorphingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final MorphingButtonStyle style;
  final double height;
  final double? width;
  final double borderRadius;

  const MorphingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.style = MorphingButtonStyle.primaryGradient,
    this.height = 56,
    this.width,
    this.borderRadius = 28,
  });

  @override
  State<MorphingButton> createState() => _MorphingButtonState();
}

class _MorphingButtonState extends State<MorphingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      HapticFeedback.lightImpact();
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    BoxDecoration decoration;
    TextStyle textStyle;

    switch (widget.style) {
      case MorphingButtonStyle.primaryGradient:
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: AuraColors.auraGradientPrimary,
          boxShadow: [
            BoxShadow(
              color: AuraColors.auraViolet.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        );
        textStyle = AuraTypography.labelButton(isDark: true).copyWith(
          color: Colors.white,
          fontSize: 16,
        );
        break;

      case MorphingButtonStyle.glassOutline:
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: isDark ? AuraColors.surfaceDarkElevated : AuraColors.surfaceLightElevated,
          border: Border.all(
            color: isDark ? AuraColors.glassBorderDark : AuraColors.glassBorderLight,
            width: 1.2,
          ),
        );
        textStyle = AuraTypography.labelButton(isDark: isDark).copyWith(
          fontSize: 16,
        );
        break;

      case MorphingButtonStyle.subtleDark:
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: isDark ? const Color(0xFF1E2130) : const Color(0xFFE5E7EB),
        );
        textStyle = AuraTypography.labelButton(isDark: isDark).copyWith(
          fontSize: 15,
        );
        break;
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: decoration,
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: textStyle.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(widget.text, style: textStyle),
                  ],
                ),
        ),
      ),
    );
  }
}
