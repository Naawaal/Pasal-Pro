import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';

/// Reusable selling price input field for sales entry
///
/// Features:
/// - Currency formatting with "Rs " prefix
/// - Decimal number validation with red error border
/// - Focus state styling (blue border + shadow)
/// - Semantic labels and hints for accessibility
/// - Tab/Enter keyboard navigation
/// - Real-time validation feedback
///
/// Props:
/// - controller: TextEditingController for price value
/// - focusNode: FocusNode for focus management
/// - onSubmitted: Callback when user presses Enter (submit sale)
/// - onChanged: Callback for real-time price changes
class PriceInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSubmitted;
  final Function(String) onChanged;

  const PriceInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
    required this.onChanged,
  });

  @override
  State<PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<PriceInputField> {
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

  /// Validate that input is a positive decimal number
  String _validatePrice(String value) {
    if (value.isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Must be a valid number';
    }
    if (price <= 0) {
      return 'Must be greater than 0';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final borderColor = _validatePrice(widget.controller.text).isNotEmpty
        ? errorColor
        : (_isFocused ? primaryColor : Colors.grey[300]!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selling Price',
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
          child: Semantics(
            container: true,
            label: 'Selling price in rupees',
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                label: const Text('Price'),
                hintText: '0.00',
                helperText: _validatePrice(widget.controller.text).isNotEmpty
                    ? null
                    : 'Enter selling price per unit',
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
                prefixText: 'Rs ',
                prefixStyle: TextStyle(
                  fontSize: SalesSpacing.fieldInputFontSize,
                  fontWeight: FontWeight.w500,
                ),
                errorText: _validatePrice(widget.controller.text).isEmpty
                    ? null
                    : _validatePrice(widget.controller.text),
                errorStyle: TextStyle(
                  fontSize: SalesSpacing.fieldErrorFontSize,
                  color: errorColor,
                ),
                suffixIcon: _validatePrice(widget.controller.text).isNotEmpty
                    ? Icon(AppIcons.error, color: errorColor, size: 20)
                    : null,
              ),
              onChanged: (value) {
                setState(() {}); // Update error state
                widget.onChanged(value);
              },
              onSubmitted: (_) => widget.onSubmitted?.call(),
            ),
          ),
        ),
      ],
    );
  }
}
