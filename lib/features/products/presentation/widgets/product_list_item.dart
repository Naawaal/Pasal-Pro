import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/theme/app_theme.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

/// List item for product rows.
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
    final theme = Theme.of(context);
    final isInactive = !product.isActive;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppSpacing.paddingMedium,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                AppIcons.package,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            AppSpacing.hMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      decoration: isInactive
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  AppSpacing.xxSmall,
                  Row(
                    children: [
                      Icon(
                        AppIcons.rupee,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      AppSpacing.hXSmall,
                      Text(
                        '${product.sellingPrice.toStringAsFixed(2)} / pc',
                        style: theme.textTheme.bodyMedium,
                      ),
                      AppSpacing.hMedium,
                      Icon(
                        AppIcons.carton,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      AppSpacing.hXSmall,
                      Text(
                        product.piecesPerCarton.toString(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  AppSpacing.xxSmall,
                  Row(
                    children: [
                      Icon(
                        product.isLowStock
                            ? AppIcons.alertTriangle
                            : AppIcons.checkCircle,
                        size: 14,
                        color: product.isLowStock
                            ? AppTheme.lowStockColor
                            : AppTheme.profitColor,
                      ),
                      AppSpacing.hXSmall,
                      Text(
                        'Stock: ${product.stockPieces}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: product.isLowStock
                              ? AppTheme.lowStockColor
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (product.category != null) ...[
                        AppSpacing.hMedium,
                        Icon(
                          AppIcons.tag,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        AppSpacing.hXSmall,
                        Text(
                          product.category!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(AppIcons.edit),
                  tooltip: 'Edit',
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(AppIcons.packagePlus),
                  tooltip: 'Adjust stock',
                  onPressed: onAdjustStock,
                ),
                IconButton(
                  icon: Icon(isInactive ? AppIcons.unlock : AppIcons.lock),
                  tooltip: isInactive ? 'Activate' : 'Deactivate',
                  onPressed: onToggleActive,
                ),
                IconButton(
                  icon: const Icon(AppIcons.delete),
                  tooltip: 'Delete',
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
