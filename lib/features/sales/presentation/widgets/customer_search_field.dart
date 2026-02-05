import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';

/// Reusable customer search field for sales entry (optional)
///
/// Handles:
/// - Real-time customer search filtering (name + phone)
/// - Optional customer selection for credit sales
/// - Dropdown display of matching customers
/// - Selected customer info display (name + credit balance)
/// - Clear functionality
///
/// Props:
/// - controller: TextEditingController for input
/// - focusNode: FocusNode for focus management
/// - customers: List of all customers to search from
/// - onCustomerSelected: Callback when customer is selected
/// - selectedCustomer: Currently selected customer (optional)
class CustomerSearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<Customer> customers;
  final Function(Customer) onCustomerSelected;
  final Customer? selectedCustomer;

  const CustomerSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.customers,
    required this.onCustomerSelected,
    this.selectedCustomer,
  });

  @override
  State<CustomerSearchField> createState() => _CustomerSearchFieldState();
}

class _CustomerSearchFieldState extends State<CustomerSearchField> {
  List<Customer> _searchResults = [];
  bool _showSearchDropdown = false;

  /// Handle customer search with name and phone filtering
  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchDropdown = false;
      });
      return;
    }

    final results = widget.customers
        .where(
          (c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              (c.phone?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();

    setState(() {
      _searchResults = results;
      _showSearchDropdown = results.isNotEmpty;
    });
  }

  /// Handle customer selection from dropdown
  void _selectCustomer(Customer customer) {
    widget.onCustomerSelected(customer);
    controller.text = '${customer.name} (${customer.phone ?? "No phone"})';
    setState(() {
      _showSearchDropdown = false;
      _searchResults = [];
    });
  }

  /// Clear search and selection
  void _clearSearch() {
    widget.controller.clear();
    setState(() {
      _showSearchDropdown = false;
      _searchResults = [];
    });
  }

  TextEditingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer (Optional)',
          style: TextStyle(
            fontSize: SalesSpacing.fieldLabelFontSize,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const Gap(SalesSpacing.inputFieldSpacing),
        Stack(
          children: [
            // Search input field
            TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(AppIcons.user, size: 20),
                hintText: 'Search customer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    SalesSpacing.inputBorderRadius,
                  ),
                ),
                contentPadding: SalesSpacing.getInputFieldPadding(),
                suffixIcon: widget.controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(AppIcons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onChanged: (value) {
                _handleSearch(value);
              },
            ),

            // Search dropdown results
            if (_showSearchDropdown && _searchResults.isNotEmpty)
              Positioned(
                top: SalesSpacing.inputFieldHeight,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(
                    SalesSpacing.inputBorderRadius,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final customer = _searchResults[index];
                        return ListTile(
                          title: Text(customer.name),
                          subtitle: Text(customer.phone ?? 'No phone'),
                          onTap: () => _selectCustomer(customer),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Selected customer info display
        if (widget.selectedCustomer != null)
          Padding(
            padding: SalesSpacing.getInputFieldPadding(),
            child: Container(
              padding: SalesSpacing.getInputFieldPadding(),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius - 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedCustomer!.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Credit: Rs ${widget.selectedCustomer!.balance.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
