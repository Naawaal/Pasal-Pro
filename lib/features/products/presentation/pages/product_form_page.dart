import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/domain/usecases/create_product.dart';
import 'package:pasal_pro/features/products/domain/usecases/update_product.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';

/// Modern product form with flat design
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
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isSaving = false;
  String? _selectedImagePath;
  final ImagePicker _imagePicker = ImagePicker();

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
      _imageUrlController.text = product.imageUrl ?? '';
      _selectedImagePath = product.imageUrl;
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
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = PasalColorToken.background.token.resolve(context);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final primaryLight = primaryColor.withValues(alpha: 0.1);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEditing ? 'Edit Product' : 'Add Product',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ResponsiveRowColumn(
            layout: AppResponsive.shouldStack(context)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            children: [
              // Main form fields (left side / full width on mobile)
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Padding(
                  padding: AppResponsive.getPagePadding(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSection(
                        context,
                        title: 'Basic Information',
                        icon: AppIcons.info,
                        primaryColor: primaryColor,
                        primaryLight: primaryLight,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Product Name',
                            hint: 'Enter product name',
                            validator: _requiredText,
                          ),
                          SizedBox(
                            height: AppResponsive.getSectionGap(context),
                          ),
                          ResponsiveRowColumn(
                            layout: AppResponsive.shouldStack(context)
                                ? ResponsiveRowColumnType.COLUMN
                                : ResponsiveRowColumnType.ROW,
                            children: [
                              ResponsiveRowColumnItem(
                                rowFlex: 1,
                                child: _buildTextField(
                                  controller: _categoryController,
                                  label: 'Category',
                                  hint: 'Optional',
                                ),
                              ),
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
                                child: _buildTextField(
                                  controller: _barcodeController,
                                  label: 'Barcode / SKU',
                                  hint: 'Optional',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppResponsive.getSectionGap(context) + 8,
                      ),
                      _buildImageUploadSection(
                        context,
                        primaryColor: primaryColor,
                        primaryLight: primaryLight,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                      SizedBox(
                        height: AppResponsive.getSectionGap(context) + 8,
                      ),
                      _buildSection(
                        context,
                        title: 'Pricing',
                        icon: AppIcons.rupee,
                        primaryColor: primaryColor,
                        primaryLight: primaryLight,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        children: [
                          ResponsiveRowColumn(
                            layout: AppResponsive.shouldStack(context)
                                ? ResponsiveRowColumnType.COLUMN
                                : ResponsiveRowColumnType.ROW,
                            children: [
                              ResponsiveRowColumnItem(
                                rowFlex: 1,
                                child: _buildNumberField(
                                  controller: _costController,
                                  label: 'Cost Price',
                                  hint: 'Per piece',
                                  validator: _requiredNonNegative,
                                ),
                              ),
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
                                child: _buildNumberField(
                                  controller: _sellingController,
                                  label: 'Selling Price',
                                  hint: 'Per piece',
                                  validator: _requiredNonNegative,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppResponsive.getSectionGap(context) + 8,
                      ),
                      _buildSection(
                        context,
                        title: 'Inventory',
                        icon: AppIcons.warehouse,
                        primaryColor: primaryColor,
                        primaryLight: primaryLight,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        children: [
                          ResponsiveRowColumn(
                            layout: AppResponsive.shouldStack(context)
                                ? ResponsiveRowColumnType.COLUMN
                                : ResponsiveRowColumnType.ROW,
                            children: [
                              ResponsiveRowColumnItem(
                                rowFlex: 1,
                                child: _buildIntField(
                                  controller: _piecesPerCartonController,
                                  label: 'Pieces per Carton',
                                  hint: 'e.g., 24',
                                  validator: _requiredPositiveInt,
                                ),
                              ),
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
                                child: _buildIntField(
                                  controller: _stockController,
                                  label: 'Current Stock',
                                  hint: 'Pieces',
                                  validator: _requiredNonNegativeInt,
                                ),
                              ),
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
                                child: _buildIntField(
                                  controller: _lowStockController,
                                  label: 'Low Stock Alert',
                                  hint: 'Threshold',
                                  validator: _requiredNonNegativeInt,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppResponsive.getSectionGap(context) + 8,
                      ),
                      ResponsiveRowColumn(
                        layout: AppResponsive.shouldStack(context)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        children: [
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ),
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
                            rowFlex: 2,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProduct,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isSaving)
                                    const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  if (_isSaving) const SizedBox(width: 8),
                                  Text(
                                    _isEditing
                                        ? 'Save Changes'
                                        : 'Create Product',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppResponsive.getPagePadding(context).top,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required List<Widget> children,
  }) {
    final sectionStyle = BoxStyler()
        .paddingAll(20)
        .borderRounded(12)
        .color(surfaceColor)
        .borderAll(color: borderColor);

    return Box(
      style: sectionStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Box(
                style: BoxStyler()
                    .paddingAll(8)
                    .borderRounded(8)
                    .color(primaryLight),
                child: StyledIcon(
                  icon: icon,
                  style: IconStyler().size(18).color(primaryColor),
                ),
              ),
              const SizedBox(width: 12),
              StyledText(
                title,
                style: TextStyler()
                    .style(PasalTextStyleToken.title.token.mix())
                    .color(textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
    );
  }

  Widget _buildIntField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
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
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
      isActive: existing?.isActive ?? true,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      quantityType: existing?.quantityType ?? 'units',
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
      SnackBar(
        content: Text(message),
        backgroundColor: PasalColorToken.error.token.resolve(context),
      ),
    );
  }

  /// Pick an image file from local storage
  Future<void> _pickImageFile() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final bytes = await file.length();

        // Validate file size (max 5MB)
        if (bytes > 5 * 1024 * 1024) {
          _showError('Image must be smaller than 5MB');
          return;
        }

        setState(() {
          _selectedImagePath = file.path;
          _imageUrlController.text = file.path;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  /// Build product image upload section with preview
  Widget _buildImageUploadSection(
    BuildContext context, {
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return _buildSection(
      context,
      title: 'Product Image',
      icon: AppIcons.image,
      primaryColor: primaryColor,
      primaryLight: primaryLight,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      textPrimary: textPrimary,
      children: [
        // Image preview
        if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty)
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: _selectedImagePath!.startsWith('http')
                    ? NetworkImage(_selectedImagePath!)
                    : FileImage(File(_selectedImagePath!)) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(AppIcons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _selectedImagePath = null;
                      _imageUrlController.clear();
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
          ),
        // URL input field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Image URL (Internet)',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.startsWith('http')) {
                  setState(() => _selectedImagePath = value);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Paste URL or browse local file',
                style: TextStyle(fontSize: 12, color: textSecondary),
              ),
            ),
            OutlinedButton.icon(
              onPressed: _pickImageFile,
              icon: const Icon(AppIcons.upload, size: 16),
              label: const Text('Browse'),
            ),
          ],
        ),
      ],
    );
  }
}
