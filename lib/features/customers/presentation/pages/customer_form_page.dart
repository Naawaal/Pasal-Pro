import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/presentation/providers/customer_providers.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/widgets/pasal_button.dart';
import 'package:pasal_pro/core/widgets/pasal_dialog.dart';
import 'package:pasal_pro/core/widgets/pasal_text_field.dart';

/// Form page for creating and editing customers
class CustomerFormPage extends ConsumerStatefulWidget {
  final Customer? customer;

  const CustomerFormPage({super.key, this.customer});

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _creditLimitController;
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _phoneController = TextEditingController(
      text: widget.customer?.phone ?? '',
    );
    _creditLimitController = TextEditingController(
      text: widget.customer?.creditLimit.toString() ?? '0',
    );
    _notesController = TextEditingController(
      text: widget.customer?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _creditLimitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Handle form submission (create or update)
  Future<void> _handleSubmit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    setState(() => _isLoading = true);

    try {
      final customer = Customer(
        id: widget.customer?.id ?? 0,
        name: _nameController.text.trim(),
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        balance: widget.customer?.balance ?? 0,
        creditLimit: double.tryParse(_creditLimitController.text) ?? 0,
        totalPurchases: widget.customer?.totalPurchases ?? 0,
        transactionCount: widget.customer?.transactionCount ?? 0,
        isActive: true,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        createdAt: widget.customer?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = ref.read(customerNotifierProvider.notifier);

      if (widget.customer == null) {
        // Create new customer
        await notifier.createCustomer(customer);
        AppLogger.info('Customer created: ${customer.name}');
      } else {
        // Update existing customer
        await notifier.updateCustomer(customer);
        AppLogger.info('Customer updated: ${customer.name}');
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      AppLogger.error('Failed to save customer: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceAlt = PasalColorToken.surfaceAlt.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);
    return Scaffold(
      appBar: AppBar(
        title: StyledText(
          widget.customer == null ? 'Add Customer' : 'Edit Customer',
          style: TextStyler()
              .style(PasalTextStyleToken.title.token.mix())
              .color(textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppResponsive.getPagePadding(context),
        child: Form(
          key: _formKey,
          child: ResponsiveRowColumn(
            layout: AppResponsive.shouldStack(context)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Name
                    PasalTextField(
                      controller: _nameController,
                      label: 'Customer Name',
                      hint: 'Enter customer name',
                      prefixIcon: AppIcons.user,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Customer name is required';
                        }
                        return null;
                      },
                    ),
                    AppSpacing.medium,

                    // Phone Number
                    PasalTextField(
                      controller: _phoneController,
                      label: 'Phone Number (Optional)',
                      hint: 'Enter phone number',
                      prefixIcon: AppIcons.phone,
                    ),
                    AppSpacing.medium,

                    // Credit Limit
                    PasalTextField(
                      controller: _creditLimitController,
                      label: 'Credit Limit',
                      hint: 'Enter credit limit (0 = unlimited)',
                      prefixIcon: AppIcons.creditCard,
                      keyboardType: TextInputType.number,
                    ),
                    AppSpacing.medium,

                    // Notes
                    PasalTextField(
                      controller: _notesController,
                      label: 'Notes (Optional)',
                      hint: 'Add any notes about the customer',
                      maxLines: 4,
                      minLines: 4,
                    ),
                    AppSpacing.xLarge,

                    // Display current balance and purchases (if editing)
                    if (widget.customer != null) ...[
                      Box(
                        style: BoxStyler()
                            .paddingAll(12)
                            .borderRounded(8)
                            .color(surfaceAlt)
                            .borderAll(color: borderColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                              'Customer Summary',
                              style: TextStyler()
                                  .style(PasalTextStyleToken.body.token.mix())
                                  .fontWeight(FontWeight.w600)
                                  .color(textPrimary),
                            ),
                            AppSpacing.small,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Current Balance:'),
                                Text(
                                  'Rs. ${widget.customer!.balance.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.xSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Purchases:'),
                                Text(
                                  'Rs. ${widget.customer!.totalPurchases.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.xSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Transactions:'),
                                Text(
                                  widget.customer!.transactionCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.xLarge,
                    ],

                    // Submit Button
                    ResponsiveRowColumn(
                      layout: AppResponsive.shouldStack(context)
                          ? ResponsiveRowColumnType.COLUMN
                          : ResponsiveRowColumnType.ROW,
                      children: [
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: PasalButton(
                            label: widget.customer == null
                                ? 'Add Customer'
                                : 'Update Customer',
                            onPressed: _isLoading ? null : _handleSubmit,
                            isLoading: _isLoading,
                            variant: PasalButtonVariant.primary,
                            fullWidth: true,
                          ),
                        ),

                        // Delete button (if editing)
                        if (widget.customer != null) ...[
                          ResponsiveRowColumnItem(
                            child: SizedBox(
                              width: AppResponsive.shouldStack(context)
                                  ? 0
                                  : AppResponsive.getSectionGap(context),
                              height: AppResponsive.shouldStack(context)
                                  ? AppResponsive.getSectionGap(context)
                                  : 0,
                            ),
                          ),
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child: PasalButton(
                              label: 'Delete Customer',
                              onPressed: _isLoading
                                  ? null
                                  : () => _showDeleteConfirmation(errorColor),
                              variant: PasalButtonVariant.destructive,
                              fullWidth: true,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(Color errorColor) {
    PasalConfirmDialog.show(
      context,
      title: 'Delete Customer?',
      message:
          'Are you sure you want to delete "${widget.customer!.name}"?\n\nThis action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleDelete();
      }
    });
  }

  /// Handle customer deletion
  Future<void> _handleDelete() async {
    setState(() => _isLoading = true);
    try {
      final notifier = ref.read(customerNotifierProvider.notifier);
      await notifier.deleteCustomer(widget.customer!.id, hardDelete: false);
      AppLogger.info('Customer deleted: ${widget.customer!.name}');
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      AppLogger.error('Failed to delete customer: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
