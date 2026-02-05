import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

/// Modern flat product list item with smooth interactions using Mix
class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onAdjustStock;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;

  const ProductListItem({
    super.key,
    required this.product,
    this.onEdit,
    this.onAdjustStock,
    this.onDelete,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final isInactive = !product.isActive;
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);

    return PressableBox(
      onPress: () {},
      style: BoxStyler()
          .paddingAll(16.0)
          .borderRounded(12.0)
          .color(surfaceColor)
          .borderAll(color: borderColor)
          .onHovered(BoxStyler().color(surfaceHover)),
      child: Row(
        children: [
          // Product icon
          Box(
            style: BoxStyler()
                .width(48)
                .height(48)
                .borderRounded(10.0)
                .color(primaryColor.withValues(alpha: 0.1)),
            child: StyledIcon(
              icon: AppIcons.package,
              style: IconStyler().size(24).color(primaryColor),
            ),
          ),
          const SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StyledText(
                        product.name,
                        style: TextStyler()
                            .fontSize(14)
                            .fontWeight(FontWeight.w600)
                            .decoration(
                              isInactive
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            )
                            .color(textPrimary),
                      ),
                    ),
                    if (isInactive)
                      _buildBadge(context, 'Inactive', errorColor),
                    if (product.isLowStock && !isInactive)
                      _buildBadge(
                        context,
                        'Low Stock',
                        AppColors.warningOrange,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    _buildInfoChip(
                      context,
                      icon: AppIcons.rupee,
                      label:
                          '${CurrencyFormatter.format(product.sellingPrice)} / pc',
                    ),
                    _buildInfoChip(
                      context,
                      icon: AppIcons.package,
                      label: 'Stock: ${product.stockPieces}',
                    ),
                    _buildInfoChip(
                      context,
                      icon: AppIcons.carton,
                      label: '${product.piecesPerCarton} pcs/carton',
                    ),
                    if (product.category != null)
                      _buildInfoChip(
                        context,
                        icon: AppIcons.tag,
                        label: product.category!,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                context,
                icon: AppIcons.edit,
                tooltip: 'Edit',
                onPressed: onEdit,
              ),
              const SizedBox(width: 4),
              _buildActionButton(
                context,
                icon: AppIcons.packagePlus,
                tooltip: 'Adjust Stock',
                onPressed: onAdjustStock,
              ),
              const SizedBox(width: 4),
              _buildActionButton(
                context,
                icon: isInactive ? AppIcons.unlock : AppIcons.lock,
                tooltip: isInactive ? 'Activate' : 'Deactivate',
                onPressed: onToggleActive,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    return Box(
      style: BoxStyler()
          .paddingX(8.0)
          .paddingY(4.0)
          .borderRounded(6.0)
          .color(color.withValues(alpha: 0.1)),
      child: StyledText(
        label,
        style: TextStyler()
            .fontSize(11)
            .fontWeight(FontWeight.w600)
            .color(color),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StyledIcon(
          icon: icon,
          style: IconStyler().size(14).color(textSecondary),
        ),
        const SizedBox(width: 4),
        StyledText(
          label,
          style: TextStyler().fontSize(13).color(textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    VoidCallback? onPressed,
  }) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return Tooltip(
      message: tooltip,
      child: PressableBox(
        onPress: onPressed,
        style: BoxStyler().width(36).height(36).borderRounded(8.0),
        child: StyledIcon(
          icon: icon,
          style: IconStyler().size(18).color(textSecondary),
        ),
      ),
    );
  }
}
