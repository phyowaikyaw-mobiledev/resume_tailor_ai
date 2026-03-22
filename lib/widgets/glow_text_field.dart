import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlowTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final IconData icon;

  const GlowTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 6,
  });

  @override
  State<GlowTextField> createState() => _GlowTextFieldState();
}

class _GlowTextFieldState extends State<GlowTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            Icon(
              widget.icon,
              size: 14,
              color: _isFocused ? AppColors.accent : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w700,
                color: _isFocused ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Field with glow effect
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused ? AppColors.accent.withOpacity(0.6) : AppColors.surfaceBorder,
              width: _isFocused ? 1.5 : 1,
            ),
            color: AppColors.surfaceElevated,
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Focus(
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            child: TextField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.6,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.5),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
