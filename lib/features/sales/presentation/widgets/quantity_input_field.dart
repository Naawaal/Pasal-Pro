import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';

/// Reusable quantity input field for sales entry
///
/// Features:
/// - Positive integer validation with red error border
/// - Focus state styling (blue border + shadow)
/// - Semantic labels and hints for accessibility
/// - Tab/Enter keyboard navigation
/// - Real-time validation feedback
///
/// Props:
/// - controller: TextEditingController for quantity value
/// - focusNode: FocusNode for focus management
/// - onNextField: Callback when user presses Tab/Enter (move to next field)
/// - onChanged: Callback for real-time qty changes
class QuantityInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback? onNextField;

  const QuantityInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onNextField,
  });

  @override
  State<QuantityInputField> createState() => _QuantityInputFieldState();
}

class _QuantityInputFieldState extends State<QuantityInputField> {
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = widget.focusNode.hasFocus);
  }

  /// Validate that input is a positive integer
  String _validateQuantity(String value) {
    if (value.isEmpty) {
      return 'Quantity is required';
    }
    final qty = int.tryParse(value);
    if (qty == null) {
      return 'Must be a number';
    }
    if (qty <= 0) {
      return 'Must be greater than 0';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final borderColor = _validateQuantity(widget.controller.text).isNotEmpty
        ? errorColor
        : (_isFocused ? primaryColor : Colors.grey[300]!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity (units)',
          style: TextStyle(
            fontSize: SalesSpacing.fieldLabelFontSize,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const Gap(SalesSpacing.inputFieldSpacing),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SalesSpacing.inputBorderRadius),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: const Text('Qty'),
              hintText: '1',
              helperText: _validateQuantity(widget.controller.text).isNotEmpty
                  ? null
                  : 'Enter number of units',
              helperMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius,
                ),
                borderSide: BorderSide(color: borderColor, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius,
                ),
                borderSide: BorderSide(color: primaryColor, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius,
                ),
                borderSide: BorderSide(color: errorColor, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius,
                ),
                borderSide: BorderSide(color: errorColor, width: 2.0),
              ),
              contentPadding: SalesSpacing.getInputFieldPadding(),
              errorText: _validateQuantity(widget.controller.text).isEmpty
                  ? null
                  : _validateQuantity(widget.controller.text),
              errorStyle: TextStyle(
                fontSize: SalesSpacing.fieldErrorFontSize,
                color: errorColor,
              ),
              suffixIcon: _validateQuantity(widget.controller.text).isNotEmpty
                  ? Icon(AppIcons.error, color: errorColor, size: 20)
                  : null,
            ),
            onChanged: (value) {
              setState(() {}); // Update error state
              widget.onChanged(value);
            },
            onSubmitted: (_) => widget.onNextField?.call(),
          ),
        ),
      ],
    );
  }
}
