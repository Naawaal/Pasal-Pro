import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Reusable Mix-based button for Pasal Pro
///
/// Supports variants, sizes, icons, loading state, and full-width layout.
enum PasalButtonVariant { primary, secondary, destructive, ghost }

enum PasalButtonSize { small, medium, large }

class PasalButton extends StatelessWidget {
  static const double _iconSize = 18;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool iconRight;
  final bool isLoading;
  final bool fullWidth;
  final PasalButtonVariant variant;
  final PasalButtonSize size;

  const PasalButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.iconRight = false,
    this.isLoading = false,
    this.fullWidth = false,
    this.variant = PasalButtonVariant.primary,
    this.size = PasalButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final primary = PasalColorToken.primary.token.resolve(context);
    final onPrimary = PasalColorToken.onPrimary.token.resolve(context);
    final surface = PasalColorToken.surface.token.resolve(context);
    final surfaceAlt = PasalColorToken.surfaceAlt.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final border = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final error = PasalColorToken.error.token.resolve(context);

    final radius = PasalRadiusToken.medium.token.resolve(context);
    final padding = _getPadding(context);
    final radiusValue = radius.x;

    final isDisabled = onPressed == null || isLoading;
    final colors = _getColors(
      primary: primary,
      onPrimary: onPrimary,
      surface: surface,
      surfaceAlt: surfaceAlt,
      surfaceHover: surfaceHover,
      border: border,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      error: error,
    );

    final baseStyle = BoxStyler()
        .paddingX(padding.horizontal)
        .paddingY(padding.vertical)
        .borderRounded(radiusValue)
        .color(colors.background)
        .borderAll(color: colors.borderColor);

    final hoverStyle = colors.hoverBackground != null
        ? BoxStyler().color(colors.hoverBackground!)
        : null;

    final content = _buildContent(colors.textColor, context);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: PressableBox(
        onPress: isDisabled ? null : onPressed,
        style: hoverStyle == null ? baseStyle : baseStyle.onHovered(hoverStyle),
        child: content,
      ),
    );
  }

  _ButtonPadding _getPadding(BuildContext context) {
    final horizontal = switch (size) {
      PasalButtonSize.small => PasalSpaceToken.small.token.resolve(context),
      PasalButtonSize.medium => PasalSpaceToken.medium.token.resolve(context),
      PasalButtonSize.large => PasalSpaceToken.large.token.resolve(context),
    };

    final vertical = switch (size) {
      PasalButtonSize.small => PasalSpaceToken.xSmall.token.resolve(context),
      PasalButtonSize.medium => PasalSpaceToken.small.token.resolve(context),
      PasalButtonSize.large => PasalSpaceToken.medium.token.resolve(context),
    };

    return _ButtonPadding(horizontal: horizontal, vertical: vertical);
  }

  Widget _buildContent(Color textColor, BuildContext context) {
    final textStyle = TextStyler()
        .style(PasalTextStyleToken.button.token.mix())
        .color(textColor);

    final iconWidget = icon == null
        ? null
        : StyledIcon(
            icon: icon!,
            style: IconStyler().size(_iconSize).color(textColor),
          );

    final spinnerColor = textColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
            ),
          ),
        if (isLoading && (icon != null || label.isNotEmpty))
          SizedBox(width: PasalSpaceToken.small.token.resolve(context)),
        if (iconWidget != null && !iconRight) ...[
          iconWidget,
          SizedBox(width: PasalSpaceToken.small.token.resolve(context)),
        ],
        StyledText(label, style: textStyle),
        if (iconWidget != null && iconRight) ...[
          SizedBox(width: PasalSpaceToken.small.token.resolve(context)),
          iconWidget,
        ],
      ],
    );
  }

  _ButtonColors _getColors({
    required Color primary,
    required Color onPrimary,
    required Color surface,
    required Color surfaceAlt,
    required Color surfaceHover,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color error,
  }) {
    return switch (variant) {
      PasalButtonVariant.primary => _ButtonColors(
        background: primary,
        hoverBackground: surfaceHover,
        textColor: onPrimary,
        borderColor: primary,
      ),
      PasalButtonVariant.secondary => _ButtonColors(
        background: surface,
        hoverBackground: surfaceHover,
        textColor: textPrimary,
        borderColor: border,
      ),
      PasalButtonVariant.destructive => _ButtonColors(
        background: error,
        hoverBackground: surfaceHover,
        textColor: onPrimary,
        borderColor: error,
      ),
      PasalButtonVariant.ghost => _ButtonColors(
        background: surfaceAlt.withValues(alpha: 0.3),
        hoverBackground: surfaceHover,
        textColor: textSecondary,
        borderColor: Colors.transparent,
      ),
    };
  }
}

class _ButtonColors {
  final Color background;
  final Color? hoverBackground;
  final Color textColor;
  final Color borderColor;

  const _ButtonColors({
    required this.background,
    required this.hoverBackground,
    required this.textColor,
    required this.borderColor,
  });
}

class _ButtonPadding {
  final double horizontal;
  final double vertical;

  const _ButtonPadding({required this.horizontal, required this.vertical});
}

/// Icon-only button using Mix tokens
class PasalIconButton extends StatelessWidget {
  static const double _iconSize = 18;

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final PasalButtonVariant variant;
  final PasalButtonSize size;

  const PasalIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.variant = PasalButtonVariant.ghost,
    this.size = PasalButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final primary = PasalColorToken.primary.token.resolve(context);
    final onPrimary = PasalColorToken.onPrimary.token.resolve(context);
    final surface = PasalColorToken.surface.token.resolve(context);
    final surfaceAlt = PasalColorToken.surfaceAlt.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final border = PasalColorToken.border.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final error = PasalColorToken.error.token.resolve(context);

    final radius = PasalRadiusToken.medium.token.resolve(context).x;
    final padding = _getIconPadding(context);

    final colors = _ButtonColors(
      background: switch (variant) {
        PasalButtonVariant.primary => primary,
        PasalButtonVariant.secondary => surface,
        PasalButtonVariant.destructive => error,
        PasalButtonVariant.ghost => surfaceAlt.withValues(alpha: 0.3),
      },
      hoverBackground: surfaceHover,
      textColor: switch (variant) {
        PasalButtonVariant.primary => onPrimary,
        PasalButtonVariant.secondary => textSecondary,
        PasalButtonVariant.destructive => onPrimary,
        PasalButtonVariant.ghost => textSecondary,
      },
      borderColor: switch (variant) {
        PasalButtonVariant.secondary => border,
        _ => Colors.transparent,
      },
    );

    final button = PressableBox(
      onPress: onPressed,
      style: BoxStyler()
          .paddingX(padding)
          .paddingY(padding)
          .borderRounded(radius)
          .color(colors.background)
          .borderAll(color: colors.borderColor)
          .onHovered(BoxStyler().color(colors.hoverBackground!)),
      child: StyledIcon(
        icon: icon,
        style: IconStyler().size(_iconSize).color(colors.textColor),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }

  double _getIconPadding(BuildContext context) {
    return switch (size) {
      PasalButtonSize.small => PasalSpaceToken.xSmall.token.resolve(context),
      PasalButtonSize.medium => PasalSpaceToken.small.token.resolve(context),
      PasalButtonSize.large => PasalSpaceToken.medium.token.resolve(context),
    };
  }
}
