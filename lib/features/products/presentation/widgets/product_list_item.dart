import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/app_theme.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

/// Modern flat product list item with smooth interactions
class ProductListItem extends StatefulWidget {
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
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInactive = !widget.product.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            // Product icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                AppIcons.package,
                color: theme.colorScheme.primary,
                size: 24,
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
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            decoration: isInactive
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      if (isInactive)
                        _buildBadge(
                          context,
                          'Inactive',
                          theme.colorScheme.error,
                        ),
                      if (widget.product.isLowStock && !isInactive)
                        _buildBadge(
                          context,
                          'Low Stock',
                          AppTheme.lowStockColor,
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
                            '${CurrencyFormatter.format(widget.product.sellingPrice)} / pc',
                      ),
                      _buildInfoChip(
                        context,
                        icon: AppIcons.package,
                        label: 'Stock: ${widget.product.stockPieces}',
                      ),
                      _buildInfoChip(
                        context,
                        icon: AppIcons.carton,
                        label: '${widget.product.piecesPerCarton} pcs/carton',
                      ),
                      if (widget.product.category != null)
                        _buildInfoChip(
                          context,
                          icon: AppIcons.tag,
                          label: widget.product.category!,
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
                  onPressed: widget.onEdit,
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  context,
                  icon: AppIcons.packagePlus,
                  tooltip: 'Adjust Stock',
                  onPressed: widget.onAdjustStock,
                ),
                const SizedBox(width: 4),
                _buildActionButton(
                  context,
                  icon: isInactive ? AppIcons.unlock : AppIcons.lock,
                  tooltip: isInactive ? 'Activate' : 'Deactivate',
                  onPressed: widget.onToggleActive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
