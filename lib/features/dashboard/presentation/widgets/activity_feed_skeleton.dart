import 'package:flutter/material.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/dashboard/constants/dashboard_spacing.dart';

/// Skeleton loading state for activity feed
/// Shows shimmer animation while data is being fetched
class ActivityFeedSkeleton extends StatefulWidget {
  final int itemCount;

  const ActivityFeedSkeleton({super.key, this.itemCount = 5});

  @override
  State<ActivityFeedSkeleton> createState() => _ActivityFeedSkeletonState();
}

class _ActivityFeedSkeletonState extends State<ActivityFeedSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
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
    return ListView.separated(
      itemCount: widget.itemCount,
      separatorBuilder: (context, index) => Divider(
        color: PasalColorToken.border.token.resolve(context),
        height: 16.0,
      ),
      itemBuilder: (context, index) =>
          _ActivityItemSkeleton(animationController: _animationController),
    );
  }
}

/// Single skeleton item in activity feed
class _ActivityItemSkeleton extends StatelessWidget {
  final AnimationController animationController;

  const _ActivityItemSkeleton({required this.animationController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DashboardSpacing.activityItemHeight,
      child: Row(
        children: [
          // Icon skeleton
          _ShimmerBox(
            width: DashboardSpacing.activityIconSize,
            height: DashboardSpacing.activityIconSize,
            animationController: animationController,
            borderRadius: 6.0,
          ),
          SizedBox(width: 12.0),

          // Text content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ShimmerBox(
                  width: 100.0,
                  height: 13.0,
                  animationController: animationController,
                ),
                SizedBox(height: 6.0),
                _ShimmerBox(
                  width: 150.0,
                  height: 12.0,
                  animationController: animationController,
                ),
              ],
            ),
          ),

          // Amount skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ShimmerBox(
                width: 80.0,
                height: 13.0,
                animationController: animationController,
              ),
              SizedBox(height: 6.0),
              _ShimmerBox(
                width: 60.0,
                height: 11.0,
                animationController: animationController,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer effect box for skeleton screens
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
                (shimmerMove - 0.2).clamp(-1.0, 1.0),
                shimmerMove.clamp(-1.0, 1.0),
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
