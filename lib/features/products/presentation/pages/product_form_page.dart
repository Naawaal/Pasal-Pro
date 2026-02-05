import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/widgets/pasal_button.dart';
import 'package:pasal_pro/core/widgets/pasal_text_field.dart';
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
        title: StyledText(
          _isEditing ? 'Edit Product' : 'Add New Product',
          style: TextStyler()
              .style(PasalTextStyleToken.title.token.mix())
              .color(textPrimary),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: AppResponsive.getPagePadding(context),
            child: Column(
              children: [
                // Two-column layout on desktop, single column on mobile
                if (AppResponsive.isMultiColumn(context))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildLeftColumn(
                          context,
                          primaryColor: primaryColor,
                          primaryLight: primaryLight,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                      ),
                      SizedBox(width: AppResponsive.getSectionGap(context)),
                      Expanded(
                        child: _buildRightColumn(
                          context,
                          primaryColor: primaryColor,
                          primaryLight: primaryLight,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildLeftColumn(
                        context,
                        primaryColor: primaryColor,
                        primaryLight: primaryLight,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                      SizedBox(height: AppResponsive.getSectionGap(context)),
                      _buildRightColumn(
                        context,
                        primaryColor: primaryColor,
                        primaryLight: primaryLight,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                SizedBox(height: AppResponsive.getSectionGap(context)),
                _buildActionButtons(context, primaryColor),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Left column: Basic Info, Pricing, Inventory
  Widget _buildLeftColumn(
    BuildContext context, {
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      children: [
        // Basic Information Section
        _buildFormSection(
          context,
          title: 'Basic Information',
          icon: AppIcons.info,
          primaryColor: primaryColor,
          primaryLight: primaryLight,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          children: [
            _buildStyledTextField(
              controller: _nameController,
              label: 'Product Name',
              hint: 'e.g., Basmati Rice',
              icon: AppIcons.package,
              keyboardType: TextInputType.text,
              validator: _requiredText,
            ),
            SizedBox(height: AppResponsive.getSectionGap(context) * 0.8),
            Row(
              children: [
                Expanded(
                  child: _buildStyledTextField(
                    controller: _categoryController,
                    label: 'Category',
                    hint: 'Optional',
                    icon: AppIcons.tag,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(width: AppResponsive.getSectionGap(context) * 0.8),
                Expanded(
                  child: _buildStyledTextField(
                    controller: _barcodeController,
                    label: 'SKU/Barcode',
                    hint: 'Optional',
                    icon: AppIcons.barcode,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppResponsive.getSectionGap(context)),

        // Pricing Section
        _buildFormSection(
          context,
          title: 'Pricing',
          icon: AppIcons.rupee,
          primaryColor: primaryColor,
          primaryLight: primaryLight,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStyledTextField(
                    controller: _costController,
                    label: 'Cost Price',
                    hint: '0.00',
                    icon: AppIcons.cash,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _requiredNonNegative,
                  ),
                ),
                SizedBox(width: AppResponsive.getSectionGap(context) * 0.8),
                Expanded(
                  child: _buildStyledTextField(
                    controller: _sellingController,
                    label: 'Selling Price',
                    hint: '0.00',
                    icon: AppIcons.dollarSign,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _requiredNonNegative,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildProfitDisplay(),
          ],
        ),
        SizedBox(height: AppResponsive.getSectionGap(context)),

        // Inventory Section
        _buildFormSection(
          context,
          title: 'Inventory',
          icon: AppIcons.warehouse,
          primaryColor: primaryColor,
          primaryLight: primaryLight,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStyledTextField(
                    controller: _piecesPerCartonController,
                    label: 'Pieces/Carton',
                    hint: 'e.g., 24',
                    icon: AppIcons.carton,
                    keyboardType: TextInputType.number,
                    validator: _requiredPositiveInt,
                  ),
                ),
                SizedBox(width: AppResponsive.getSectionGap(context) * 0.8),
                Expanded(
                  child: _buildStyledTextField(
                    controller: _stockController,
                    label: 'Stock',
                    hint: 'Pieces',
                    icon: AppIcons.box,
                    keyboardType: TextInputType.number,
                    validator: _requiredNonNegativeInt,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.getSectionGap(context) * 0.8),
            _buildStyledTextField(
              controller: _lowStockController,
              label: 'Low Stock Alert',
              hint: 'Alert when below...',
              icon: AppIcons.alertCircle,
              keyboardType: TextInputType.number,
              validator: _requiredNonNegativeInt,
            ),
          ],
        ),
      ],
    );
  }

  /// Right column: Image upload
  Widget _buildRightColumn(
    BuildContext context, {
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      children: [
        _buildImageUploadSectionRedesigned(
          context,
          primaryColor: primaryColor,
          primaryLight: primaryLight,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ],
    );
  }

  /// Build styled form section with icon and title
  Widget _buildFormSection(
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
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: primaryColor, size: 20),
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
          ),
          // Section content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// Build a styled text field with icon
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return PasalTextField(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: icon,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  /// Display profit margin between cost and selling price
  Widget _buildProfitDisplay() {
    final cost = double.tryParse(_costController.text) ?? 0;
    final selling = double.tryParse(_sellingController.text) ?? 0;
    final profit = selling > 0 ? ((selling - cost) / selling) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PasalColorToken.success.token
            .resolve(context)
            .withValues(alpha: 0.1),
        border: Border.all(
          color: PasalColorToken.success.token
              .resolve(context)
              .withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StyledText(
            'Profit Margin',
            style: TextStyler()
                .style(PasalTextStyleToken.caption.token.mix())
                .color(PasalColorToken.textSecondary.token.resolve(context)),
          ),
          StyledText(
            '${profit.toStringAsFixed(1)}%',
            style: TextStyler()
                .style(PasalTextStyleToken.title.token.mix())
                .color(PasalColorToken.success.token.resolve(context)),
          ),
        ],
      ),
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

  /// Build redesigned image upload section with better visual hierarchy
  Widget _buildImageUploadSectionRedesigned(
    BuildContext context, {
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return _buildFormSection(
      context,
      title: 'Product Image',
      icon: AppIcons.image,
      primaryColor: primaryColor,
      primaryLight: primaryLight,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      textPrimary: textPrimary,
      children: [
        // Image preview with delete button
        if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: PasalColorToken.surfaceAlt.token.resolve(context),
                  ),
                  child: _selectedImagePath!.startsWith('http')
                      ? Image.network(
                          _selectedImagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  AppIcons.image,
                                  size: 48,
                                  color: PasalColorToken.textSecondary.token
                                      .resolve(context),
                                ),
                                const SizedBox(height: 8),
                                StyledText(
                                  'Failed to load image',
                                  style: TextStyler()
                                      .style(
                                        PasalTextStyleToken.caption.token.mix(),
                                      )
                                      .color(
                                        PasalColorToken.textSecondary.token
                                            .resolve(context),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Image.file(
                          File(_selectedImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              AppIcons.image,
                              size: 48,
                              color: PasalColorToken.textSecondary.token
                                  .resolve(context),
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: PasalIconButton(
                  icon: AppIcons.close,
                  tooltip: 'Remove image',
                  variant: PasalButtonVariant.secondary,
                  size: PasalButtonSize.small,
                  onPressed: () {
                    setState(() {
                      _selectedImagePath = null;
                      _imageUrlController.clear();
                    });
                  },
                ),
              ),
            ],
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
              color: PasalColorToken.surfaceAlt.token
                  .resolve(context)
                  .withValues(alpha: 0.6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AppIcons.image, size: 48, color: primaryColor),
                const SizedBox(height: 12),
                StyledText(
                  'No Image Selected',
                  style: TextStyler()
                      .style(PasalTextStyleToken.title.token.mix())
                      .color(textPrimary),
                ),
                const SizedBox(height: 4),
                StyledText(
                  'Upload or paste a product image',
                  style: TextStyler()
                      .style(PasalTextStyleToken.caption.token.mix())
                      .color(textSecondary),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        StyledText(
          'Image URL',
          style: TextStyler()
              .style(PasalTextStyleToken.caption.token.mix())
              .color(textSecondary),
        ),
        const SizedBox(height: 8),
        PasalTextField(
          controller: _imageUrlController,
          hint: 'https://example.com/image.jpg',
          prefixIcon: AppIcons.upload,
          keyboardType: TextInputType.url,
          onChanged: (value) {
            if (value.startsWith('http')) {
              setState(() => _selectedImagePath = value);
            }
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: PasalButton(
            label: 'Browse from Device',
            icon: AppIcons.upload,
            onPressed: _pickImageFile,
            variant: PasalButtonVariant.secondary,
            fullWidth: true,
          ),
        ),
      ],
    );
  }

  /// Build action buttons (Cancel and Save)
  Widget _buildActionButtons(BuildContext context, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: PasalButton(
            label: 'Cancel',
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
            variant: PasalButtonVariant.secondary,
            fullWidth: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: PasalButton(
            label: _isEditing ? 'Save Changes' : 'Create Product',
            onPressed: _isSaving ? null : _saveProduct,
            isLoading: _isSaving,
            variant: PasalButtonVariant.primary,
            fullWidth: true,
          ),
        ),
      ],
    );
  }
}
