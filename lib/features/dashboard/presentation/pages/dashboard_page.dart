import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/dashboard/constants/dashboard_spacing.dart';
import 'package:pasal_pro/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/metric_card.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/metric_card_skeleton.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/quick_actions.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/recent_activity.dart';

/// Modern dashboard with analytics, KPIs, and real-time updates
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();
    _lastUpdated = DateTime.now();
    // Setup auto-refresh every 30 seconds
    Future.delayed(const Duration(seconds: 30), _autoRefresh);
  }

  /// Auto-refresh every 30 seconds
  void _autoRefresh() {
    if (mounted) {
      _refreshDashboard();
      // Schedule next refresh
      Future.delayed(const Duration(seconds: 30), _autoRefresh);
    }
  }

  /// Manual refresh handler
  Future<void> _refreshDashboard() async {
    // Invalidate all dashboard providers to trigger refetch (before setState)
    ref.invalidate(todaySalesAmountProvider);
    ref.invalidate(todayProfitProvider);
    ref.invalidate(todayTransactionCountProvider);
    ref.invalidate(lowStockCountProvider);
    ref.invalidate(recentActivityProvider);
    ref.invalidate(todayCashSalesProvider);
    ref.invalidate(todayCreditSalesProvider);
    ref.invalidate(totalOutstandingCreditProvider);
    ref.invalidate(totalCustomersProvider);
    ref.invalidate(storeStatsProvider);
    ref.invalidate(dashboardTrendsProvider);

    if (mounted) {
      setState(() {
        _lastUpdated = DateTime.now();
      });

      // Show brief feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard refreshed'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todaySalesState = ref.watch(todaySalesAmountProvider);
    final todayProfitState = ref.watch(todayProfitProvider);
    final transactionCountState = ref.watch(todayTransactionCountProvider);
    final lowStockCountState = ref.watch(lowStockCountProvider);
    final trendsState = ref.watch(dashboardTrendsProvider);
    final surfaceAlt = PasalColorToken.surfaceAlt.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final primaryLight = primaryColor.withValues(alpha: 0.1);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return Container(
      color: surfaceAlt,
      padding: DashboardSpacing.getResponsiveSectionPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            context,
            primaryColor: primaryColor,
            primaryLight: primaryLight,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          SizedBox(height: DashboardSpacing.sectionGap / 2), // 16px
          _buildRefreshBar(
            context,
            primaryColor: primaryColor,
            textSecondary: textSecondary,
          ),
          SizedBox(height: DashboardSpacing.sectionGap), // 32px
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDashboard,
              color: primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: MaxWidthBox(
                  maxWidth: AppResponsive.getMaxContentWidth(context),
                  child: Column(
                    children: [
                      _buildMetricsGrid(
                        context,
                        todaySalesState,
                        todayProfitState,
                        transactionCountState,
                        lowStockCountState,
                        trendsState,
                      ),
                      SizedBox(height: DashboardSpacing.sectionGap), // 32px
                      ResponsiveRowColumn(
                        layout: AppResponsive.shouldStack(context)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        children: [
                          ResponsiveRowColumnItem(
                            rowFlex: 2,
                            child: RecentActivity(),
                          ),
                          ResponsiveRowColumnItem(
                            child: SizedBox(
                              height: AppResponsive.shouldStack(context)
                                  ? DashboardSpacing.sectionGap
                                  : 0,
                              width: AppResponsive.shouldStack(context)
                                  ? 0
                                  : DashboardSpacing.sectionGap,
                            ),
                          ),
                          ResponsiveRowColumnItem(
                            rowFlex: 1,
                            child: QuickActions(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Refresh status bar with last updated time
  Widget _buildRefreshBar(
    BuildContext context, {
    required Color primaryColor,
    required Color textSecondary,
  }) {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    String timeAgo;
    if (difference.inSeconds < 60) {
      timeAgo = 'Just now';
    } else if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = '${difference.inHours}h ago';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(AppIcons.sync, size: 16, color: textSecondary),
            const SizedBox(width: 8),
            Text(
              'Last updated: $timeAgo',
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
        IconButton(
          icon: Icon(AppIcons.sync, size: 20, color: primaryColor),
          tooltip: 'Refresh dashboard',
          onPressed: _refreshDashboard,
          iconSize: 20,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: const EdgeInsets.all(6),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required Color primaryColor,
    required Color primaryLight,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(AppIcons.dashboard, color: primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Here\'s what\'s happening with your store today',
                style: TextStyle(fontSize: 13, color: textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    AsyncValue<double> salesState,
    AsyncValue<double> profitState,
    AsyncValue<int> transactionState,
    AsyncValue<int> lowStockState,
    AsyncValue<List<TrendData>> trendsState,
  ) {
    // Responsive column count: 3 cols @1366px, 4 cols @1920px+
    final cols = AppResponsive.getValue<int>(
      context,
      small: 1,
      medium: 2,
      large: 3,
      xLarge: 4,
    );

    return trendsState.when(
      data: (trends) => GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: DashboardSpacing.cardGap,
        crossAxisSpacing: DashboardSpacing.cardGap,
        childAspectRatio: 1.6,
        children: [
          _buildMetricCardAsync(
            title: 'Today\'s Sales',
            state: salesState,
            format: (v) => CurrencyFormatter.format(v),
            icon: AppIcons.trendingUp,
            trend: trends[0],
          ),
          _buildMetricCardAsync(
            title: 'Total Profit',
            state: profitState,
            format: (v) => CurrencyFormatter.format(v),
            icon: AppIcons.wallet,
            trend: trends[1],
          ),
          _buildMetricCardAsyncInt(
            title: 'Transactions',
            state: transactionState,
            icon: AppIcons.receipt,
            trend: trends[2],
          ),
          _buildMetricCardAsyncInt(
            title: 'Low Stock Items',
            state: lowStockState,
            icon: AppIcons.warehouse,
            trend: trends[3],
          ),
        ],
      ),
      loading: () => GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: DashboardSpacing.cardGap,
        crossAxisSpacing: DashboardSpacing.cardGap,
        childAspectRatio: 1.6,
        children: List.generate(4, (_) => const MetricCardSkeleton()),
      ),
      error: (error, stackTrace) => GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: DashboardSpacing.cardGap,
        crossAxisSpacing: DashboardSpacing.cardGap,
        childAspectRatio: 1.6,
        children: [
          _buildMetricCardAsync(
            title: 'Today\'s Sales',
            state: salesState,
            format: (v) => CurrencyFormatter.format(v),
            icon: AppIcons.trendingUp,
            trend: TrendData(
              percentage: '—',
              isPositive: false,
              label: 'vs yesterday',
            ),
          ),
          _buildMetricCardAsync(
            title: 'Total Profit',
            state: profitState,
            format: (v) => CurrencyFormatter.format(v),
            icon: AppIcons.wallet,
            trend: TrendData(
              percentage: '—',
              isPositive: false,
              label: 'vs yesterday',
            ),
          ),
          _buildMetricCardAsyncInt(
            title: 'Transactions',
            state: transactionState,
            icon: AppIcons.receipt,
            trend: TrendData(
              percentage: '—',
              isPositive: false,
              label: 'vs yesterday',
            ),
          ),
          _buildMetricCardAsyncInt(
            title: 'Low Stock Items',
            state: lowStockState,
            icon: AppIcons.warehouse,
            trend: TrendData(
              percentage: '—',
              isPositive: false,
              label: 'vs yesterday',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCardAsync({
    required String title,
    required AsyncValue<double> state,
    required String Function(double) format,
    required IconData icon,
    required TrendData trend,
  }) {
    return state.when(
      data: (value) => MetricCard(
        title: title,
        value: format(value),
        trend:
            '${trend.isPositive ? '↑' : '↓'} ${trend.percentage} ${trend.label}',
        isPositive: trend.isPositive,
        icon: icon,
        timestamp: 'Last updated: just now',
      ),
      loading: () => const MetricCardSkeleton(),
      error: (error, stackTrace) => MetricCard(
        title: title,
        value: '—',
        trend: 'Error loading data',
        isPositive: false,
        icon: icon,
      ),
    );
  }

  Widget _buildMetricCardAsyncInt({
    required String title,
    required AsyncValue<int> state,
    required IconData icon,
    required TrendData trend,
  }) {
    return state.when(
      data: (value) => MetricCard(
        title: title,
        value: value.toString(),
        trend:
            '${trend.isPositive ? '↑' : '↓'} ${trend.percentage} ${trend.label}',
        isPositive: trend.isPositive,
        icon: icon,
        timestamp: 'Last updated: just now',
      ),
      loading: () => const MetricCardSkeleton(),
      error: (error, stackTrace) => MetricCard(
        title: title,
        value: '—',
        trend: 'Error loading data',
        isPositive: false,
        icon: icon,
      ),
    );
  }
}
