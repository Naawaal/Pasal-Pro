import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/presentation/providers/customer_providers.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/customer_search_field.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/price_input_field.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/product_search_field.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/profit_display_box.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/quantity_input_field.dart';

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
  // Resolve color tokens at form level
  late Color _textSecondary;
  late TextEditingController _productController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _customerController;
  late FocusNode _productFocus;
  late FocusNode _quantityFocus;
  late FocusNode _priceFocus;
  late FocusNode _customerFocus;

  // Selected state
  late Product _selectedProduct;
  late Customer? _selectedCustomer;

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
    // Initialize with null/empty product state
    _selectedProduct = Product(
      id: 0,
      name: '',
      costPrice: 0,
      sellingPrice: 0,
      piecesPerCarton: 1,
      stockPieces: 0,
      lowStockThreshold: 5,
      barcode: null,
      category: null,
      imageUrl: null,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _selectedCustomer = null;
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

  /// Calculate profit based on cost, price, and quantity
  double _calculateProfit() {
    if (_selectedProduct.name.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return 0.0;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final sellingPrice = double.tryParse(_priceController.text) ?? 0.0;
    final costPrice = _selectedProduct.costPrice;

    return (sellingPrice - costPrice) * quantity;
  }

  /// Check if form is valid
  bool _isFormValid() {
    return _selectedProduct.name.isNotEmpty &&
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
        .addItem(_selectedProduct, quantity, sellingPrice);

    // Attempt to persist to database asynchronously
    _persistSaleToDatabase();

    // Clear form
    setState(() {
      _selectedProduct = Product(
        id: 0,
        name: '',
        costPrice: 0,
        sellingPrice: 0,
        piecesPerCarton: 1,
        stockPieces: 0,
        lowStockThreshold: 5,
        barcode: null,
        category: null,
        imageUrl: null,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _selectedCustomer = null;
      _productController.clear();
      _quantityController.text = '1';
      _priceController.clear();
      _customerController.clear();
    });

    _productFocus.requestFocus();
  }

  /// Persist the current sale to database
  Future<void> _persistSaleToDatabase() async {
    try {
      final dataSourceAsync = ref.read(salesLocalDataSourceProvider);

      await dataSourceAsync.when(
        data: (dataSource) async {
          final currentNotifier = ref.read(currentSaleProvider.notifier);
          await currentNotifier.saveSaleToDatabase(dataSource);

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sale added (DB sync pending)'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textSecondary = PasalColorToken.textSecondary.token.resolve(context);
  }

  @override
  Widget build(BuildContext context) {
    // Watch products and customers for search dropdowns
    final productsAsync = ref.watch(productsControllerProvider);
    final customersAsync = ref.watch(customersProvider);

    return Card(
      color: PasalColorToken.surface.token.resolve(context),
      child: Padding(
        padding: SalesSpacing.getFormPadding(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENTRY FORM',
                style: TextStyle(
                  fontSize: SalesSpacing.fieldLabelFontSize,
                  fontWeight: FontWeight.w600,
                  color: _textSecondary,
                ),
              ),
              SalesSpacing.medium,

              // Product search field
              productsAsync.when(
                data: (products) => ProductSearchField(
                  controller: _productController,
                  focusNode: _productFocus,
                  products: products,
                  selectedProduct: _selectedProduct,
                  onProductSelected: (product) {
                    setState(() {
                      _selectedProduct = product;
                      _priceController.text = product.sellingPrice.toString();
                    });
                    _quantityFocus.requestFocus();
                  },
                ),
                loading: () => const SizedBox(
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Text('Error loading products: $error'),
              ),
              SalesSpacing.medium,

              // Customer search field (optional)
              customersAsync.when(
                data: (customers) => CustomerSearchField(
                  controller: _customerController,
                  focusNode: _customerFocus,
                  customers: customers,
                  selectedCustomer: _selectedCustomer,
                  onCustomerSelected: (customer) {
                    setState(() => _selectedCustomer = customer);
                  },
                ),
                loading: () => const SizedBox(
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) =>
                    Text('Error loading customers: $error'),
              ),
              SalesSpacing.medium,

              // Quantity input field
              QuantityInputField(
                controller: _quantityController,
                focusNode: _quantityFocus,
                onChanged: (_) => setState(() {}),
                onNextField: () => _priceFocus.requestFocus(),
              ),
              SalesSpacing.medium,

              // Price input field
              PriceInputField(
                controller: _priceController,
                focusNode: _priceFocus,
                onChanged: (_) => setState(() {}),
                onSubmitted: _submitEntry,
              ),
              SalesSpacing.large,

              // Profit display box (when form is valid)
              if (_isFormValid())
                ProfitDisplayBox(
                  profit: _calculateProfit(),
                  showAnimation: true,
                )
              else
                const SizedBox.shrink(),

              SalesSpacing.medium,

              // Submit button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isFormValid() ? _submitEntry : null,
                  icon: const Icon(AppIcons.add),
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
