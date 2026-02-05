import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';

/// Reusable product search field with dropdown results
///
/// Handles:
/// - Real-time search filtering (name + barcode)
/// - Dropdown display of matching products
/// - Selected product info display
/// - Clear functionality
///
/// Props:
/// - controller: TextEditingController for input
/// - focusNode: FocusNode for focus management
/// - products: List of all products to search from
/// - onProductSelected: Callback when product is selected
/// - onSearchChanged: Callback for search query changes
class ProductSearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<Product> products;
  final Function(Product) onProductSelected;
  final Function(String)? onSearchChanged;
  final Product? selectedProduct;

  const ProductSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.products,
    required this.onProductSelected,
    this.onSearchChanged,
    this.selectedProduct,
  });

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  List<Product> _searchResults = [];
  bool _showSearchDropdown = false;

  /// Handle product search with name and barcode filtering
  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchDropdown = false;
      });
      return;
    }

    final results = widget.products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              (p.barcode?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();

    setState(() {
      _searchResults = results;
      _showSearchDropdown = results.isNotEmpty;
    });

    widget.onSearchChanged?.call(query);
  }

  /// Handle product selection from dropdown
  void _selectProduct(Product product) {
    widget.onProductSelected(product);
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

  @override
  Widget build(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product',
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
                prefixIcon: const Icon(AppIcons.package, size: 20),
                hintText: 'Search or create...',
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
                        final product = _searchResults[index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                            'Cost: Rs ${product.costPrice.toStringAsFixed(2)}',
                          ),
                          onTap: () => _selectProduct(product),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Selected product info display
        if (widget.selectedProduct != null &&
            widget.selectedProduct!.name.isNotEmpty)
          Padding(
            padding: SalesSpacing.getInputFieldPadding(),
            child: Container(
              padding: SalesSpacing.getInputFieldPadding(),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                border: Border.all(color: AppColors.primaryBlue, width: 1),
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius - 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedProduct!.name,
                      style: TextStyle(
                        fontSize: SalesSpacing.fieldLabelFontSize,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Cost: Rs ${widget.selectedProduct!.costPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: SalesSpacing.fieldLabelFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
