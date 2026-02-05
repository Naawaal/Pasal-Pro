import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';

/// Reusable profit display box for sales entry form
///
/// Displays calculated profit with:
/// - Green highlight styling
/// - Large 28px profit value (matches dashboard MetricCard)
/// - Scale-in entry animation
/// - Success color scheme
///
/// Props:
/// - profit: Calculated profit amount to display
/// - showAnimation: Enable entry animation (default true)
class ProfitDisplayBox extends StatefulWidget {
  final double profit;
  final bool showAnimation;

  const ProfitDisplayBox({
    super.key,
    required this.profit,
    this.showAnimation = true,
  });

  @override
  State<ProfitDisplayBox> createState() => _ProfitDisplayBoxState();
}

class _ProfitDisplayBoxState extends State<ProfitDisplayBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
        milliseconds: SalesSpacing.entryAddAnimationDurationMs,
      ),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.showAnimation) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: SalesSpacing.getProfitBoxPadding(),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.successGreen, width: 1.5),
              borderRadius: BorderRadius.circular(
                SalesSpacing.inputBorderRadius,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profit',
                  style: TextStyle(
                    fontSize: SalesSpacing.profitBoxLabelFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.successGreen,
                  ),
                ),
                SalesSpacing.xSmall,
                Text(
                  'Rs ${widget.profit.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: SalesSpacing.profitBoxFontSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
