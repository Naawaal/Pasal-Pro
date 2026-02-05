import 'package:flutter/material.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';

/// Individual product item in the search list
/// Modern flat design with subtle hover states
class ProductSearchItem extends StatefulWidget {
  final Product product;
  final Function(Product) onTap;

  const ProductSearchItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductSearchItem> createState() => _ProductSearchItemState();
}

class _ProductSearchItemState extends State<ProductSearchItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.product),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: _isHovering
              ? PasalColorToken.surfaceAlt.token.resolve(context)
              : Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        color: PasalColorToken.textPrimary.token.resolve(
                          context,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.product.stockPieces} pcs',
                      style: TextStyle(
                        color: widget.product.isLowStock
                            ? PasalColorToken.error.token.resolve(context)
                            : PasalColorToken.textSecondary.token.resolve(
                                context,
                              ),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Rs ${widget.product.sellingPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: PasalColorToken.textPrimary.token.resolve(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
