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
  late Color _textPrimary;
  bool _showCustomerField = false;
  late String
  _selectedQuantityMode; // 'units' or 'weight' - user's selected mode
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
    _selectedQuantityMode = 'units'; // Default mode
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
      quantityType: 'units',
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

    // Parse quantity based on active mode (units = int, weight = double)
    final quantity = _selectedQuantityMode == 'weight'
        ? (double.tryParse(_quantityController.text) ?? 0.0)
        : (int.tryParse(_quantityController.text) ?? 0);

    final sellingPrice = double.tryParse(_priceController.text) ?? 0.0;
    final costPrice = _selectedProduct.costPrice;

    return (sellingPrice - costPrice) * quantity;
  }

  /// Check if form is valid
  bool _isFormValid() {
    if (_selectedProduct.name.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return false;
    }

    // Validate price
    final priceValid =
        double.tryParse(_priceController.text) != null &&
        double.tryParse(_priceController.text)! > 0;

    if (!priceValid) return false;

    // Validate quantity based on active mode
    if (_selectedQuantityMode == 'weight') {
      final weight = double.tryParse(_quantityController.text);
      return weight != null && weight > 0;
    } else {
      final quantity = int.tryParse(_quantityController.text);
      return quantity != null && quantity > 0;
    }
  }

  /// Submit the sale entry and persist to database
  void _submitEntry() {
    if (!_isFormValid()) return;

    // Parse quantity based on active mode
    final quantity = _selectedQuantityMode == 'weight'
        ? double.parse(_quantityController.text)
        : int.parse(_quantityController.text).toDouble();

    final sellingPrice = double.parse(_priceController.text);

    // Add to current sale (daily log will watch this provider)
    ref
        .read(currentSaleProvider.notifier)
        .addItem(_selectedProduct, quantity, sellingPrice);

    // Attempt to persist to database asynchronously
    _persistSaleToDatabase();

    _resetForm();

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

          ref.invalidate(todaySalesProvider);

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
    _textPrimary = PasalColorToken.textPrimary.token.resolve(context);
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
              _buildHeader(),
              SalesSpacing.medium,
              _buildProductField(productsAsync),
              SalesSpacing.medium,
              _buildQuantityField(),
              SalesSpacing.medium,
              _buildPriceField(),
              SalesSpacing.medium,
              _buildCustomerSection(customersAsync),
              SalesSpacing.large,
              _buildProfitBox(),
              SalesSpacing.medium,
              _buildActionRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sale Entry',
                style: TextStyle(
                  fontSize: SalesSpacing.totalsFontSize,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              SalesSpacing.xSmall,
              Text(
                'Enter product, quantity, and price to record a sale.',
                style: TextStyle(
                  fontSize: SalesSpacing.fieldHintFontSize,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ),
        SalesSpacing.medium,
        // Toggle between units and weight modes
        Wrap(
          spacing: 8,
          children: [
            _buildModeToggleButton('units', 'Units'),
            _buildModeToggleButton('weight', 'Weight'),
          ],
        ),
      ],
    );
  }

  /// Build individual toggle button for quantity mode
  Widget _buildModeToggleButton(String mode, String label) {
    final isActive = _selectedQuantityMode == mode;
    final bgColor = isActive
        ? PasalColorToken.primary.token.resolve(context)
        : PasalColorToken.surface.token.resolve(context);
    final textColor = isActive ? Colors.white : _textSecondary;
    final borderColor = isActive
        ? PasalColorToken.primary.token.resolve(context)
        : PasalColorToken.border.token.resolve(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedQuantityMode = mode;
          // Reset quantity when switching modes
          if (mode == 'weight') {
            _quantityController.clear();
          } else {
            _quantityController.text = '1';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildProductField(AsyncValue<List<Product>> productsAsync) {
    return productsAsync.when(
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
    );
  }

  Widget _buildCustomerField(AsyncValue<List<Customer>> customersAsync) {
    return customersAsync.when(
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
      error: (error, stack) => Text('Error loading customers: $error'),
    );
  }

  Widget _buildQuantityField() {
    return QuantityInputField(
      controller: _quantityController,
      focusNode: _quantityFocus,
      quantityType: _selectedProduct.quantityType,
      forcedMode: _selectedQuantityMode, // User's manual selection
      onChanged: (_) => setState(() {}),
      onNextField: () => _priceFocus.requestFocus(),
    );
  }

  Widget _buildPriceField() {
    return PriceInputField(
      controller: _priceController,
      focusNode: _priceFocus,
      onChanged: (_) => setState(() {}),
      onSubmitted: _submitEntry,
    );
  }

  Widget _buildProfitBox() {
    if (!_isFormValid()) {
      return const SizedBox.shrink();
    }

    return ProfitDisplayBox(profit: _calculateProfit(), showAnimation: true);
  }

  Widget _buildCustomerSection(AsyncValue<List<Customer>> customersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() => _showCustomerField = !_showCustomerField);
          },
          icon: Icon(
            _showCustomerField ? AppIcons.close : AppIcons.userPlus,
            size: 18,
          ),
          label: Text(
            _showCustomerField ? 'Remove customer' : 'Add customer (optional)',
          ),
        ),
        if (_showCustomerField) ...[
          SalesSpacing.small,
          _buildCustomerField(customersAsync),
        ],
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: _isFormValid() ? _submitEntry : null,
            icon: const Icon(AppIcons.add),
            label: const Text('Add Sale'),
          ),
        ),
        const SizedBox(width: 12),
        TextButton.icon(
          onPressed: _resetForm,
          icon: const Icon(AppIcons.close, size: 18),
          label: const Text('Clear'),
        ),
      ],
    );
  }

  void _resetForm() {
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
        quantityType: 'units',
      );
      _selectedCustomer = null;
      _productController.clear();
      _quantityController.text = '1';
      _priceController.clear();
      _customerController.clear();
    });

    _productFocus.requestFocus();
  }
}
