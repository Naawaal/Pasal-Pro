import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale_item.dart';

/// Individual sales log row with hover effects and remove animation
///
/// Displays:
/// - Product name
/// - Quantity
/// - Unit price
/// - Profit (green highlight)
/// - Remove button (with hover hover scale)
///
/// Features:
/// - 52px row height (data-dense)
/// - 150ms hover scale transition
/// - Smooth remove animation on action
class SalesLogRow extends StatefulWidget {
  final SaleItem item;
  final VoidCallback onRemove;
  final int index;

  const SalesLogRow({
    super.key,
    required this.item,
    required this.onRemove,
    required this.index,
  });

  @override
  State<SalesLogRow> createState() => _SalesLogRowState();
}

class _SalesLogRowState extends State<SalesLogRow>
    with SingleTickerProviderStateMixin {
  late Color _textSecondary;
  late AnimationController _hoverController;
  late Animation<double> _hoverScale;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: SalesSpacing.hoverTransitionDuration,
      vsync: this,
    );

    _hoverScale = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() => _isHovering = true);
    _hoverController.forward();
  }

  void _onHoverExit() {
    setState(() => _isHovering = false);
    _hoverController.reverse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textSecondary = PasalColorToken.textSecondary.token.resolve(context);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: AnimatedBuilder(
        animation: _hoverScale,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverScale.value,
            child: Container(
              height: SalesSpacing.logRowHeight,
              padding: SalesSpacing.getLogCellPadding(),
              decoration: BoxDecoration(
                color: _isHovering ? Colors.grey[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  SalesSpacing.logBorderRadius,
                ),
              ),
              child: Row(
                children: [
                  // Product name (flex: 3)
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.item.product.name,
                      style: TextStyle(
                        fontSize: SalesSpacing.logCellFontSize,
                        color: _textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Quantity (flex: 1)
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${widget.item.quantity}',
                      style: TextStyle(
                        fontSize: SalesSpacing.logCellFontSize,
                        color: _textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Unit price (flex: 1)
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Rs ${widget.item.unitPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: SalesSpacing.logCellFontSize,
                        color: _textSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  // Profit (flex: 1, green highlight)
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Rs ${widget.item.profit.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: SalesSpacing.logCellFontSize,
                        color: AppColors.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  // Remove button (32px fixed width)
                  SizedBox(
                    width: SalesSpacing.removeButtonSize,
                    child: Opacity(
                      opacity: _isHovering ? 1.0 : 0.6,
                      child: IconButton(
                        icon: const Icon(AppIcons.close, size: 18),
                        onPressed: widget.onRemove,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: SalesSpacing.removeButtonSize,
                          minHeight: SalesSpacing.removeButtonSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
