import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Reusable Mix-based text field for Pasal Pro
///
/// Applies Mix tokens for colors, spacing, and typography.
/// Supports prefix/suffix widgets, validation states, and helper text.
class PasalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool filled;
  final Color? fillColor;
  final String? helperText;
  final String? errorText;
  final String? successText;
  final bool showSuccess;

  const PasalTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.filled = true,
    this.fillColor,
    this.helperText,
    this.errorText,
    this.successText,
    this.showSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = PasalColorToken.border.token.resolve(context);
    final focusColor = PasalColorToken.primary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);
    final successColor = PasalColorToken.success.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final surface = PasalColorToken.surface.token.resolve(context);

    final radius = PasalRadiusToken.medium.token.resolve(context).x;
    final horizontalPadding = PasalSpaceToken.medium.token.resolve(context);
    final verticalPadding = PasalSpaceToken.small.token.resolve(context);

    final labelWidget = label == null
        ? null
        : StyledText(
            label!,
            style: TextStyler()
                .style(PasalTextStyleToken.caption.token.mix())
                .color(textSecondary),
          );

    final bodyStyle = PasalTextStyleToken.body.token.resolve(context);
    final captionStyle = PasalTextStyleToken.caption.token.resolve(context);
    final hintStyle = captionStyle.copyWith(color: textSecondary);

    // Determine current validation state
    final hasError = errorText != null;
    final hasSuccess = showSuccess && successText != null;

    // Build prefix widget (icon or custom widget)
    Widget? prefixWidget;
    if (prefix != null) {
      prefixWidget = prefix;
    } else if (prefixIcon != null) {
      prefixWidget = Icon(prefixIcon, size: 18, color: textSecondary);
    }

    // Build suffix widget (icon or custom widget)
    Widget? suffixWidget;
    if (suffix != null) {
      suffixWidget = suffix;
    } else if (suffixIcon != null) {
      suffixWidget = suffixIcon;
    } else if (hasSuccess) {
      // Auto-add success icon
      suffixWidget = Icon(Icons.check_circle, size: 18, color: successColor);
    }

    // Determine helper/error/success text
    String? helperOrErrorText;
    TextStyle? helperStyle;

    if (hasError) {
      helperOrErrorText = errorText;
      helperStyle = captionStyle.copyWith(color: errorColor);
    } else if (hasSuccess) {
      helperOrErrorText = successText;
      helperStyle = captionStyle.copyWith(color: successColor);
    } else if (helperText != null) {
      helperOrErrorText = helperText;
      helperStyle = captionStyle.copyWith(color: textSecondary);
    }

    // Determine border color based on state
    BorderSide getEnabledBorder() {
      if (hasError) {
        return BorderSide(color: errorColor, width: 1.5);
      } else if (hasSuccess) {
        return BorderSide(color: successColor, width: 1.5);
      }
      return BorderSide(color: borderColor, width: 1);
    }

    BorderSide getFocusedBorder() {
      if (hasError) {
        return BorderSide(color: errorColor, width: 2);
      } else if (hasSuccess) {
        return BorderSide(color: successColor, width: 2);
      }
      return BorderSide(color: focusColor, width: 2);
    }

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      style: bodyStyle.copyWith(color: textPrimary),
      decoration: InputDecoration(
        label: labelWidget,
        hintText: hint,
        hintStyle: hintStyle,
        filled: filled,
        fillColor: fillColor ?? surface,
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        helperText: helperOrErrorText,
        helperStyle: helperStyle,
        helperMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: getEnabledBorder(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: getFocusedBorder(),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
      ),
    );
  }
}
