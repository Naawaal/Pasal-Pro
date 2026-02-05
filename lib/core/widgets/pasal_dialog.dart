import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/widgets/pasal_button.dart';

/// Standardized dialog component using Mix design tokens
///
/// Provides consistent styling for all dialogs across the app.
/// Handles title, content, and action buttons with Mix token styling.
class PasalDialog extends StatelessWidget {
  const PasalDialog({
    super.key,
    this.title,
    required this.content,
    this.actions = const [],
    this.maxWidth = 400,
  });

  /// Dialog title (optional)
  final String? title;

  /// Main dialog content widget
  final Widget content;

  /// Action buttons (typically Cancel/Confirm)
  final List<Widget> actions;

  /// Maximum dialog width
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Box(
        style: BoxStyler()
            .color(surfaceColor)
            .borderRounded(12.0)
            .paddingAll(24.0)
            .maxWidth(maxWidth),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title section
              if (title != null) ...[
                StyledText(
                  title!,
                  style: TextStyler()
                      .style(PasalTextStyleToken.title.token.mix())
                      .color(textPrimary),
                ),
                AppSpacing.large,
              ],

              // Content section
              content,

              // Actions section
              if (actions.isNotEmpty) ...[
                AppSpacing.large,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      if (i > 0) AppSpacing.hSmall,
                      actions[i],
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Standardized confirmation dialog with cancel + confirm buttons
///
/// Use for simple yes/no confirmations.
/// Returns true if confirmed, false/null if cancelled.
class PasalConfirmDialog extends StatelessWidget {
  const PasalConfirmDialog({
    super.key,
    this.title = 'Confirm',
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  /// Dialog title
  final String title;

  /// Confirmation message
  final String message;

  /// Confirm button label
  final String confirmLabel;

  /// Cancel button label
  final String cancelLabel;

  /// If true, uses destructive styling for confirm button
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return PasalDialog(
      title: title,
      content: StyledText(
        message,
        style: TextStyler()
            .style(PasalTextStyleToken.body.token.mix())
            .color(PasalColorToken.textPrimary.token.resolve(context)),
      ),
      actions: [
        PasalButton(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
          variant: PasalButtonVariant.secondary,
          size: PasalButtonSize.small,
        ),
        PasalButton(
          label: confirmLabel,
          onPressed: () => Navigator.of(context).pop(true),
          variant: isDestructive
              ? PasalButtonVariant.destructive
              : PasalButtonVariant.primary,
          size: PasalButtonSize.small,
        ),
      ],
    );
  }

  /// Show confirmation dialog and return result
  static Future<bool?> show(
    BuildContext context, {
    String title = 'Confirm',
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => PasalConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }
}
