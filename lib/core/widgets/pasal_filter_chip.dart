import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Standardized filter chip using Mix design tokens
///
/// Provides consistent styling for filter/choice chips across the app.
class PasalFilterChip extends StatelessWidget {
  const PasalFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  /// Chip label text
  final String label;

  /// Whether chip is selected
  final bool selected;

  /// Callback when chip is tapped
  final ValueChanged<bool> onSelected;

  /// Optional icon to display
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final surfaceAlt = PasalColorToken.surfaceAlt.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);

    return PressableBox(
      onPress: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: PasalDurationToken.fast.token.resolve(context),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? surfaceAlt : surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? primaryColor : borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? primaryColor : textPrimary,
              ),
              const SizedBox(width: 6),
            ],
            StyledText(
              label,
              style: TextStyler()
                  .style(PasalTextStyleToken.caption.token.mix())
                  .fontWeight(FontWeight.w500)
                  .color(selected ? primaryColor : textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
