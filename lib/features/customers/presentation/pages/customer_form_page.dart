import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/presentation/providers/customer_providers.dart';

/// Form page for creating and editing customers
class CustomerFormPage extends ConsumerStatefulWidget {
  final Customer? customer;

  const CustomerFormPage({super.key, this.customer});

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
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
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer name is required')),
      );
      return;
    }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                hintText: 'Enter customer name',
                prefixIcon: const Icon(LucideIcons.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            AppSpacing.medium,

            // Phone Number
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number (Optional)',
                hintText: 'Enter phone number',
                prefixIcon: const Icon(LucideIcons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            AppSpacing.medium,

            // Credit Limit
            TextField(
              controller: _creditLimitController,
              decoration: InputDecoration(
                labelText: 'Credit Limit',
                hintText: 'Enter credit limit (0 = unlimited)',
                prefixIcon: const Icon(LucideIcons.creditCard),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            AppSpacing.medium,

            // Notes
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add any notes about the customer',
                prefixIcon: const Icon(LucideIcons.notepadText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            AppSpacing.xLarge,

            // Display current balance and purchases (if editing)
            if (widget.customer != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Summary',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    AppSpacing.small,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Balance:'),
                        Text(
                          'Rs. ${widget.customer!.balance.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.xLarge,
            ],

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        widget.customer == null
                            ? 'Add Customer'
                            : 'Update Customer',
                      ),
              ),
            ),

            // Delete button (if editing)
            if (widget.customer != null) ...[
              AppSpacing.small,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _showDeleteConfirmation,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Delete Customer'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer?'),
        content: Text(
          'Are you sure you want to delete "${widget.customer!.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDelete();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
