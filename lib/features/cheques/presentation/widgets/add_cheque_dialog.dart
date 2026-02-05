import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/widgets/pasal_button.dart';
import 'package:pasal_pro/core/widgets/pasal_dialog.dart';
import 'package:pasal_pro/core/widgets/pasal_text_field.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/presentation/providers/cheque_providers.dart';

/// Dialog to add a new cheque
class AddChequeDialog extends ConsumerStatefulWidget {
  const AddChequeDialog({super.key});

  @override
  ConsumerState<AddChequeDialog> createState() => _AddChequeDialogState();
}

class _AddChequeDialogState extends ConsumerState<AddChequeDialog> {
  late TextEditingController _partyNameController;
  late TextEditingController _chequeNumberController;
  late TextEditingController _amountController;
  late DateTime _selectedDueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _partyNameController = TextEditingController();
    _chequeNumberController = TextEditingController();
    _amountController = TextEditingController();
    _selectedDueDate = DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _partyNameController.dispose();
    _chequeNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Validate form fields
  String? _validateForm() {
    if (_partyNameController.text.trim().isEmpty) {
      return 'Party name is required';
    }

    if (_chequeNumberController.text.trim().isEmpty) {
      return 'Cheque number is required';
    }

    if (_amountController.text.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (_selectedDueDate.isBefore(DateTime.now())) {
      return 'Due date must be in the future';
    }

    return null;
  }

  /// Handle form submission
  Future<void> _handleSubmit() async {
    final validationError = _validateForm();
    if (validationError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newCheque = Cheque(
        partyName: _partyNameController.text.trim(),
        amount: double.parse(_amountController.text),
        chequeNumber: _chequeNumberController.text.trim(),
        dueDate: _selectedDueDate,
        status: 'pending',
        createdDate: DateTime.now(),
      );

      // Add cheque via provider
      await ref.read(addNewChequeProvider(newCheque).future);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cheque added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Open date picker
  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PasalDialog(
      title: 'Add Cheque',
      maxWidth: 450,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Party Name Field
          PasalTextField(
            controller: _partyNameController,
            label: 'Party Name',
            hint: 'Enter party/customer name',
            enabled: !_isLoading,
            keyboardType: TextInputType.text,
          ),
          AppSpacing.medium,

          // Cheque Number Field
          PasalTextField(
            controller: _chequeNumberController,
            label: 'Cheque Number',
            hint: 'e.g., CHQ-001',
            enabled: !_isLoading,
            keyboardType: TextInputType.text,
          ),
          AppSpacing.medium,

          // Amount Field
          PasalTextField(
            controller: _amountController,
            label: 'Amount (Rs)',
            hint: 'Enter amount',
            enabled: !_isLoading,
            keyboardType: TextInputType.number,
          ),
          AppSpacing.medium,

          // Due Date Field
          Material(
            child: InkWell(
              onTap: _isLoading ? null : _selectDueDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Due Date', style: theme.textTheme.labelSmall),
                        const SizedBox(height: 4),
                        Text(
                          _getFormattedDate(_selectedDueDate),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Icon(AppIcons.calendar, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        PasalButton(
          label: 'Cancel',
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          variant: PasalButtonVariant.secondary,
          size: PasalButtonSize.small,
        ),
        PasalButton(
          label: 'Add Cheque',
          onPressed: _isLoading ? null : _handleSubmit,
          isLoading: _isLoading,
          variant: PasalButtonVariant.primary,
          size: PasalButtonSize.small,
        ),
      ],
    );
  }

  /// Format date for display
  String _getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
