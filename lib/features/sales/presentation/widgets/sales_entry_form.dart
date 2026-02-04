import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/presentation/providers/customer_providers.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';

/// Sales Entry Form widget
///
/// Allows user to quickly enter:
/// 1. Product (search existing or create new)
/// 2. Quantity (units only, no conversion)
/// 3. Selling Price (editable per sale)
///
/// Automatically calculates: Profit = (Selling Price - Cost) × Quantity
class SalesEntryForm extends ConsumerStatefulWidget {
  const SalesEntryForm({super.key});

  @override
  ConsumerState<SalesEntryForm> createState() => _SalesEntryFormState();
}

class _SalesEntryFormState extends ConsumerState<SalesEntryForm> {
  late TextEditingController _productController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _customerController;
  late FocusNode _productFocus;
  late FocusNode _quantityFocus;
  late FocusNode _priceFocus;
  late FocusNode _customerFocus;

  Product? _selectedProduct;
  Customer? _selectedCustomer;
  List<Product> _searchResults = [];
  List<Customer> _customerSearchResults = [];
  bool _showSearchDropdown = false;
  bool _showCustomerDropdown = false;

  @override
  void initState() {
    super.initState();
    _productController = TextEditingController();
    _quantityController = TextEditingController(text: '1');
    _priceController = TextEditingController();
    _customerController = TextEditingController();
    _productFocus = FocusNode();
    _quantityFocus = FocusNode();
    _priceFocus = FocusNode();
    _customerFocus = FocusNode();
  }

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _customerController.dispose();
    _productFocus.dispose();
    _quantityFocus.dispose();
    _priceFocus.dispose();
    _customerFocus.dispose();
    super.dispose();
  }

  /// Handle product search
  void _handleProductSearch(String query, List<Product> allProducts) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchDropdown = false;
        _selectedProduct = null;
      });
      return;
    }

    final results = allProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              (p.barcode?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();

    setState(() {
      _searchResults = results;
      _showSearchDropdown = results.isNotEmpty;
      _selectedProduct = null;
    });
  }

  /// Select a product from search results
  void _selectProduct(Product product) {
    setState(() {
      _selectedProduct = product;
      _productController.text = product.name;
      _priceController.text = product.sellingPrice.toString();
      _showSearchDropdown = false;
      _searchResults = [];
    });
    _quantityFocus.requestFocus();
  }

  /// Handle customer search
  void _handleCustomerSearch(String query, List<Customer> allCustomers) {
    if (query.isEmpty) {
      setState(() {
        _customerSearchResults = [];
        _showCustomerDropdown = false;
      });
      return;
    }

    final results = allCustomers
        .where(
          (c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              (c.phone?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();

    setState(() {
      _customerSearchResults = results;
      _showCustomerDropdown = results.isNotEmpty;
    });
  }

  /// Select a customer from search results
  void _selectCustomer(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
      _customerController.text =
          '${customer.name} (${customer.phone ?? "No phone"})';
      _showCustomerDropdown = false;
      _customerSearchResults = [];
    });
  }

  /// Calculate profit based on cost, price, and quantity
  double _calculateProfit() {
    if (_selectedProduct == null ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return 0.0;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final sellingPrice = double.tryParse(_priceController.text) ?? 0.0;
    final costPrice = _selectedProduct!.costPrice;

    return (sellingPrice - costPrice) * quantity;
  }

  /// Check if form is valid
  bool _isFormValid() {
    return _selectedProduct != null &&
        _quantityController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        int.tryParse(_quantityController.text) != null &&
        int.tryParse(_quantityController.text)! > 0 &&
        double.tryParse(_priceController.text) != null &&
        double.tryParse(_priceController.text)! > 0;
  }

  /// Submit the sale entry and persist to database
  void _submitEntry() {
    if (!_isFormValid()) return;

    final quantity = int.parse(_quantityController.text);
    final sellingPrice = double.parse(_priceController.text);

    // Add to current sale (daily log will watch this provider)
    ref
        .read(currentSaleProvider.notifier)
        .addItem(_selectedProduct!, quantity, sellingPrice);

    // Attempt to persist to database asynchronously
    _persistSaleToDatabase();

    // Clear form
    setState(() {
      _selectedProduct = null;
      _productController.clear();
      _quantityController.text = '1';
      _priceController.clear();
      _showSearchDropdown = false;
      _searchResults = [];
    });

    _productFocus.requestFocus();
  }

  /// Persist the current sale to database
  Future<void> _persistSaleToDatabase() async {
    try {
      // Try to get the data source - it's a FutureProvider which returns AsyncValue
      // We need to use ref.watch which returns AsyncValue, not the actual value
      // Instead, let's use a simpler approach: just read the provider and handle the async value

      final dataSourceAsync = ref.read(salesLocalDataSourceProvider);

      // dataSourceAsync is an AsyncValue, so we can use when()
      await dataSourceAsync.when(
        data: (dataSource) async {
          // Save the current sale
          final currentNotifier = ref.read(currentSaleProvider.notifier);
          await currentNotifier.saveSaleToDatabase(dataSource);

          // Show success feedback
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Sale recorded'),
                duration: Duration(milliseconds: 800),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        loading: () async {
          // Data source is still loading
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Initializing database...'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        error: (error, stackTrace) async {
          // Error occurred - but item is still in currentSale
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sale added (DB sync pending)'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    } catch (e) {
      // Fallback error handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Sale added (DB sync pending)'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch product list for search
    final productsAsync = ref.watch(productsControllerProvider);

    return Card(
      child: Padding(
        padding: AppSpacing.paddingMedium,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENTRY FORM',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.medium,

              // Product field with search dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.xSmall,
                  Stack(
                    children: [
                      TextField(
                        controller: _productController,
                        focusNode: _productFocus,
                        decoration: InputDecoration(
                          hintText: 'Search or create...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: AppSpacing.paddingSmall,
                          suffixIcon: _productController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _productController.clear();
                                    setState(() {
                                      _selectedProduct = null;
                                      _showSearchDropdown = false;
                                      _searchResults = [];
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          productsAsync.whenData((products) {
                            _handleProductSearch(value, products);
                          });
                        },
                      ),
                      // Search dropdown
                      if (_showSearchDropdown && _searchResults.isNotEmpty)
                        Positioned(
                          top: 56,
                          left: 0,
                          right: 0,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
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
                  // Selected product info
                  if (_selectedProduct != null)
                    Padding(
                      padding: AppSpacing.paddingSmall,
                      child: Container(
                        padding: AppSpacing.paddingSmall,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.05),
                          border: Border.all(
                            color: AppColors.primaryBlue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedProduct!.name,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Cost: Rs ${_selectedProduct!.costPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              AppSpacing.medium,

              // Customer field (optional) with search dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer (Optional)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.xSmall,
                  Stack(
                    children: [
                      // Watch customers for search
                      ref
                          .watch(customersProvider)
                          .when(
                            data: (customers) {
                              return TextField(
                                controller: _customerController,
                                focusNode: _customerFocus,
                                decoration: InputDecoration(
                                  hintText: 'Search customer...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: AppSpacing.paddingSmall,
                                  suffixIcon:
                                      _customerController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _customerController.clear();
                                            setState(() {
                                              _selectedCustomer = null;
                                              _showCustomerDropdown = false;
                                              _customerSearchResults = [];
                                            });
                                          },
                                        )
                                      : null,
                                ),
                                onChanged: (value) {
                                  _handleCustomerSearch(value, customers);
                                },
                              );
                            },
                            loading: () => TextField(
                              decoration: InputDecoration(
                                hintText: 'Loading customers...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: AppSpacing.paddingSmall,
                              ),
                              enabled: false,
                            ),
                            error: (error, stack) => TextField(
                              decoration: InputDecoration(
                                hintText: 'Error loading customers',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: AppSpacing.paddingSmall,
                              ),
                              enabled: false,
                            ),
                          ),
                      // Customer search dropdown
                      if (_showCustomerDropdown &&
                          _customerSearchResults.isNotEmpty)
                        Positioned(
                          top: 56,
                          left: 0,
                          right: 0,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                itemCount: _customerSearchResults.length,
                                itemBuilder: (context, index) {
                                  final customer =
                                      _customerSearchResults[index];
                                  return ListTile(
                                    title: Text(customer.name),
                                    subtitle: Text(
                                      customer.phone ?? 'No phone',
                                    ),
                                    onTap: () => _selectCustomer(customer),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Selected customer info
                  if (_selectedCustomer != null)
                    Padding(
                      padding: AppSpacing.paddingSmall,
                      child: Container(
                        padding: AppSpacing.paddingSmall,
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.05),
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCustomer!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Credit: Rs ${_selectedCustomer!.balance.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              AppSpacing.medium,

              // Quantity field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity (units)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.xSmall,
                  TextField(
                    controller: _quantityController,
                    focusNode: _quantityFocus,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: AppSpacing.paddingSmall,
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _priceFocus.requestFocus(),
                  ),
                ],
              ),
              AppSpacing.medium,

              // Selling Price field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selling Price',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.xSmall,
                  TextField(
                    controller: _priceController,
                    focusNode: _priceFocus,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: AppSpacing.paddingSmall,
                      prefixText: 'Rs ',
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _submitEntry(),
                  ),
                ],
              ),
              AppSpacing.large,

              // Auto-calculated profit display
              if (_isFormValid())
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingMedium,
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppColors.successGreen,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profit',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          AppSpacing.xSmall,
                          Text(
                            'Rs ${_calculateProfit().toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.medium,
                  ],
                ),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isFormValid() ? _submitEntry : null,
                  icon: const Icon(Icons.add),
                  label: const Text('ADD SALE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
