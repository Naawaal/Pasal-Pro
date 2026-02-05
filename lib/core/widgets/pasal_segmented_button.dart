import 'package:flutter/material.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Standardized segmented button using Mix design tokens
///
/// Wraps Flutter's SegmentedButton with consistent styling via Mix tokens.
class PasalSegmentedButton<T> extends StatelessWidget {
  const PasalSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
  });

  /// List of button segments
  final List<ButtonSegment<T>> segments;

  /// Set of currently selected values
  final Set<T> selected;

  /// Callback when selection changes
  final ValueChanged<Set<T>> onSelectionChanged;

  /// Allow multiple selections
  final bool multiSelectionEnabled;

  /// Allow empty selection
  final bool emptySelectionAllowed;

  @override
  Widget build(BuildContext context) {
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final onPrimaryColor = PasalColorToken.onPrimary.token.resolve(context);

    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelectionEnabled: multiSelectionEnabled,
      emptySelectionAllowed: emptySelectionAllowed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return surfaceColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return onPrimaryColor;
          }
          return textPrimary;
        }),
        side: WidgetStateProperty.all(BorderSide(color: borderColor, width: 1)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
