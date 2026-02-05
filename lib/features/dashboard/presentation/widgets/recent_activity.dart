import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/dashboard/constants/dashboard_spacing.dart';
import 'package:pasal_pro/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/activity_item.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/activity_feed_skeleton.dart';

/// Recent activity feed showing latest 10 transactions
/// Modern clean list view with payment type indicators and timestamps
class RecentActivity extends ConsumerWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentActivityAsync = ref.watch(recentActivityProvider);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);

    return Container(
      padding: DashboardSpacing.getCardPadding(),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.all(color: borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(DashboardSpacing.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Title + View All link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to detailed activity log
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: PasalColorToken.primary.token.resolve(context),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DashboardSpacing.sectionGap / 2), // 16px
          // Activity list
          SizedBox(
            height: 400.0, // Fixed height for list
            child: recentActivityAsync.when(
              loading: () => const ActivityFeedSkeleton(itemCount: 5),
              error: (error, stack) => _buildErrorState(context),
              data: (activities) {
                if (activities.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView.separated(
                  itemCount: activities.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: borderColor, height: 16.0),
                  itemBuilder: (context, index) =>
                      ActivityItem(sale: activities[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state when no activities exist
  Widget _buildEmptyState(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.history, size: 48.0, color: Colors.grey[350]),
          SizedBox(height: 12.0),
          Text(
            'No activity yet',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            'Transactions will appear here',
            style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  /// Build error state when data fails to load
  Widget _buildErrorState(BuildContext context) {
    final errorColor = PasalColorToken.error.token.resolve(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.error, size: 48.0, color: errorColor),
          SizedBox(height: 12.0),
          Text(
            'Failed to load activity',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: errorColor,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            'Please try again later',
            style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
