import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';

/// Reusable quantity input field for sales entry
///
/// Features:
/// - Units mode: Positive integer validation (pieces)
/// - Weight mode: Decimal number validation (kg/grams)
/// - Toggle between units and weight based on product type or forced mode
/// - Focus state styling (blue border)
/// - Semantic labels and hints for accessibility
/// - Tab/Enter keyboard navigation
/// - Real-time validation feedback
///
/// Props:
/// - controller: TextEditingController for quantity value
/// - focusNode: FocusNode for focus management
/// - quantityType: 'units' or 'weight' (from product)
/// - forcedMode: Optional override to force a specific mode ('units' or 'weight')
/// - onNextField: Callback when user presses Tab/Enter (move to next field)
/// - onChanged: Callback for real-time qty changes
class QuantityInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback? onNextField;
  final String quantityType; // 'units' or 'weight'
  final String? forcedMode; // Optional override: 'units' or 'weight'

  const QuantityInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.quantityType,
    this.onNextField,
    this.forcedMode,
  });

  @override
  State<QuantityInputField> createState() => _QuantityInputFieldState();
}

class _QuantityInputFieldState extends State<QuantityInputField> {
  late bool _isFocused;
  late bool _hasBeenTouched;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    _hasBeenTouched = false;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QuantityInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset validation state when mode changes (user switched Units/Weight toggle)
    if (oldWidget.forcedMode != widget.forcedMode) {
      setState(() {
        _hasBeenTouched = false; // Reset error visibility
      });
    }
  }

  /// Get active mode: use forced mode if provided, otherwise use product's quantityType
  String _getActiveMode() => widget.forcedMode ?? widget.quantityType;

  /// Auto-detect weight unit based on entered value
  /// Values < 1 are displayed as grams, >= 1 as kilograms
  String _getDetectedWeightUnit() {
    final value = double.tryParse(widget.controller.text);
    if (value == null) return 'kg'; // Default to kg if invalid
    return value < 1 ? 'g' : 'kg';
  }

  /// Get detected weight unit label as a string
  String _getDetectedWeightLabel() {
    const kr = 1000.0;
    final value = double.tryParse(widget.controller.text);
    if (value == null || value == 0) return '-';

    if (value < 1) {
      // Display as grams
      final grams = value * kr;
      return '${grams.toStringAsFixed(0)}g';
    } else {
      // Display as kilograms
      return '${value.toStringAsFixed(2)}kg';
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
      // Mark as touched when focus is lost
      if (!_isFocused) {
        _hasBeenTouched = true;
      }
    });
  }

  /// Validate units mode (positive integer)
  String _validateUnits(String value) {
    if (value.isEmpty) {
      return 'Quantity is required';
    }
    final qty = int.tryParse(value);
    if (qty == null) {
      return 'Must be a whole number';
    }
    if (qty <= 0) {
      return 'Must be greater than 0';
    }
    return '';
  }

  /// Validate weight mode (positive decimal number)
  String _validateWeight(String value) {
    if (value.isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Must be a valid number';
    }
    if (weight <= 0) {
      return 'Must be greater than 0';
    }
    return '';
  }

  /// Get validation error based on mode
  String _getValidationError(String value) {
    if (_getActiveMode() == 'weight') {
      return _validateWeight(value);
    }
    return _validateUnits(value);
  }

  /// Get appropriate keyboard type based on mode
  TextInputType _getKeyboardType() {
    if (_getActiveMode() == 'weight') {
      return const TextInputType.numberWithOptions(decimal: true);
    }
    return TextInputType.number;
  }

  /// Get field label based on mode
  String _getFieldLabel() {
    if (_getActiveMode() == 'weight') {
      // Show auto-detected unit
      final unit = _getDetectedWeightUnit();
      return 'Weight ($unit)';
    }
    return 'Quantity (units)';
  }

  /// Get input hint based on mode
  String _getInputHint() {
    if (_getActiveMode() == 'weight') {
      // Show hints for both kg and g ranges
      return '0.5 (kg) or 250 (g)';
    }
    return '1';
  }

  /// Get helper text based on mode
  String _getHelperText() {
    if (_getActiveMode() == 'weight') {
      // Show auto-detected value preview
      final preview = _getDetectedWeightLabel();
      return preview != '-'
          ? 'You entered: $preview'
          : 'Enter weight (kg or g)';
    }
    return 'Enter number of units';
  }

  @override
  Widget build(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final validationError = _getValidationError(widget.controller.text);
    final borderColor = _hasBeenTouched && validationError.isNotEmpty
        ? errorColor
        : (_isFocused ? primaryColor : Colors.grey[300]!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with label (auto-detects kg/g in weight mode)
        Text(
          _getFieldLabel(),
          style: TextStyle(
            fontSize: SalesSpacing.fieldLabelFontSize,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const Gap(SalesSpacing.inputFieldSpacing),
        // Input field with dynamic label and hint based on active mode
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: _getKeyboardType(),
          decoration: InputDecoration(
            prefixIcon: const Icon(AppIcons.box, size: 20),
            label: Text(_getActiveMode() == 'weight' ? 'Weight' : 'Quantity'),
            hintText: _getInputHint(),
            helperText: (!_hasBeenTouched || validationError.isEmpty)
                ? _getHelperText()
                : null,
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
            errorText: _hasBeenTouched && validationError.isNotEmpty
                ? validationError
                : null,
            errorStyle: TextStyle(
              fontSize: SalesSpacing.fieldErrorFontSize,
              color: errorColor,
            ),
            suffixIcon: _hasBeenTouched && validationError.isNotEmpty
                ? Icon(AppIcons.error, color: errorColor, size: 20)
                : null,
          ),
          onChanged: (value) {
            setState(() {}); // Update error state
            widget.onChanged(value);
          },
          onSubmitted: (_) => widget.onNextField?.call(),
        ),
      ],
    );
  }
}
