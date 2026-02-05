import 'package:flutter/material.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/dashboard/constants/dashboard_spacing.dart';

/// Skeleton loading state for metric cards
/// Shows shimmer animation while data is being fetched
class MetricCardSkeleton extends StatefulWidget {
  const MetricCardSkeleton({super.key});

  @override
  State<MetricCardSkeleton> createState() => _MetricCardSkeletonState();
}

class _MetricCardSkeletonState extends State<MetricCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Shimmer animation: 2s loop, left to right
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = PasalColorToken.border.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);

    return Container(
      padding: DashboardSpacing.getCardPadding(),
      decoration: BoxDecoration(
        color: surfaceHover,
        border: Border.all(color: borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(DashboardSpacing.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header skeleton (title + icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(
                width: 80.0,
                height: 12.0,
                animationController: _animationController,
              ),
              _ShimmerBox(
                width: DashboardSpacing.metricIconSize,
                height: DashboardSpacing.metricIconSize,
                animationController: _animationController,
                borderRadius: 6.0,
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Value skeleton (large number)
          _ShimmerBox(
            width: 140.0,
            height: DashboardSpacing.metricValueFontSize,
            animationController: _animationController,
          ),
          const SizedBox(height: 8.0),

          // Trend skeleton
          _ShimmerBox(
            width: 100.0,
            height: 14.0,
            animationController: _animationController,
          ),
          const SizedBox(height: 4.0),

          // Timestamp skeleton
          _ShimmerBox(
            width: 120.0,
            height: 11.0,
            animationController: _animationController,
          ),
        ],
      ),
    );
  }
}

/// Shimmer effect box
/// Animates left-to-right with gradient shimmer effect
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final AnimationController animationController;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.animationController,
    this.borderRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        // Shimmer moves from -1 to 1 over 2 seconds
        final shimmerMove = animationController.value * 2 - 1;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: const Alignment(-1, 0),
              end: const Alignment(1, 0),
              stops: [
                // Dark gray base
                (shimmerMove - 0.2).clamp(-1.0, 1.0),
                // Light shimmer highlight
                shimmerMove.clamp(-1.0, 1.0),
                // Return to dark gray
                (shimmerMove + 0.2).clamp(-1.0, 1.0),
              ],
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
            ),
          ),
        );
      },
    );
  }
}
