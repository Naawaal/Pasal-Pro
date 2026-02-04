import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/theme/app_theme.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/usecases/create_product.dart';
import 'package:pasal_pro/features/products/domain/usecases/update_product.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';

/// Product create/edit form page.
class ProductFormPage extends ConsumerStatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _sellingController = TextEditingController();
  final TextEditingController _piecesPerCartonController =
      TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _lowStockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _nameController.text = product.name;
      _costController.text = product.costPrice.toStringAsFixed(2);
      _sellingController.text = product.sellingPrice.toStringAsFixed(2);
      _piecesPerCartonController.text = product.piecesPerCarton.toString();
      _stockController.text = product.stockPieces.toString();
      _lowStockController.text = product.lowStockThreshold.toString();
      _categoryController.text = product.category ?? '';
      _barcodeController.text = product.barcode ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _sellingController.dispose();
    _piecesPerCartonController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    _categoryController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Product' : 'Add Product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.paddingLarge,
          children: [
            _buildSectionTitle(context, 'Basic Info'),
            AppSpacing.formFieldGap,
            _buildTextField(
              controller: _nameController,
              label: 'Product Name',
              icon: AppIcons.package,
              validator: _requiredText,
            ),
            AppSpacing.formFieldGap,
            _buildTextField(
              controller: _categoryController,
              label: 'Category (optional)',
              icon: AppIcons.tag,
            ),
            AppSpacing.formFieldGap,
            _buildTextField(
              controller: _barcodeController,
              label: 'Barcode / SKU (optional)',
              icon: AppIcons.barcode,
            ),
            AppSpacing.formSectionGap,
            _buildSectionTitle(context, 'Pricing'),
            AppSpacing.formFieldGap,
            _buildNumberField(
              controller: _costController,
              label: 'Cost Price (per piece)',
              icon: AppIcons.cash,
              validator: _requiredNonNegative,
            ),
            AppSpacing.formFieldGap,
            _buildNumberField(
              controller: _sellingController,
              label: 'Selling Price (per piece)',
              icon: AppIcons.rupee,
              validator: _requiredNonNegative,
            ),
            AppSpacing.formSectionGap,
            _buildSectionTitle(context, 'Stock'),
            AppSpacing.formFieldGap,
            _buildIntField(
              controller: _piecesPerCartonController,
              label: 'Pieces per Carton',
              icon: AppIcons.carton,
              validator: _requiredPositiveInt,
            ),
            AppSpacing.formFieldGap,
            _buildIntField(
              controller: _stockController,
              label: 'Current Stock (pieces)',
              icon: AppIcons.inStock,
              validator: _requiredNonNegativeInt,
            ),
            AppSpacing.formFieldGap,
            _buildIntField(
              controller: _lowStockController,
              label: 'Low Stock Threshold',
              icon: AppIcons.alertTriangle,
              validator: _requiredNonNegativeInt,
            ),
            AppSpacing.formSectionGap,
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveProduct,
              icon: Icon(_isEditing ? AppIcons.save : AppIcons.add),
              label: Text(_isEditing ? 'Save Changes' : 'Create Product'),
            ),
            AppSpacing.small,
            Text(
              'Selling price should be equal to or higher than cost price.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: validator,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: validator,
    );
  }

  Widget _buildIntField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: validator,
    );
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  String? _requiredNonNegative(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null) return 'Enter a valid number.';
    if (parsed < 0) return 'Value cannot be negative.';
    return null;
  }

  String? _requiredPositiveInt(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null) return 'Enter a valid number.';
    if (parsed <= 0) return 'Value must be greater than zero.';
    return null;
  }

  String? _requiredNonNegativeInt(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null) return 'Enter a valid number.';
    if (parsed < 0) return 'Value cannot be negative.';
    return null;
  }

  Future<void> _saveProduct() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final cost = double.tryParse(_costController.text.trim()) ?? 0;
    final selling = double.tryParse(_sellingController.text.trim()) ?? 0;
    if (selling < cost) {
      _showError('Selling price must be at least the cost price.');
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime.now();
    final existing = widget.product;
    final product = Product(
      id: existing?.id ?? 0,
      name: _nameController.text.trim(),
      costPrice: cost,
      sellingPrice: selling,
      piecesPerCarton:
          int.tryParse(_piecesPerCartonController.text.trim()) ?? 1,
      stockPieces: int.tryParse(_stockController.text.trim()) ?? 0,
      lowStockThreshold: int.tryParse(_lowStockController.text.trim()) ?? 0,
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      isActive: existing?.isActive ?? true,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final result = _isEditing
        ? await ref.read(updateProductProvider)(
            UpdateProductParams(product: product),
          )
        : await ref.read(createProductProvider)(
            CreateProductParams(product: product),
          );

    result.fold(
      onSuccess: (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing ? 'Product updated.' : 'Product created.',
              ),
            ),
          );
          Navigator.of(context).pop(true);
        }
      },
      onError: (failure) => _showError(failure.message),
    );

    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.lossColor),
    );
  }
}
