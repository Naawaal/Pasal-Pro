import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:pasal_pro/features/dashboard/presentation/widgets/metric_card.dart';
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
    setState(() {
      _lastUpdated = DateTime.now();
    });

    // Invalidate all dashboard providers to trigger refetch
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

    // Show brief feedback
    if (mounted) {
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

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildRefreshBar(context),
          const SizedBox(height: 24),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDashboard,
              color: Theme.of(context).colorScheme.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildMetricsGrid(
                      context,
                      todaySalesState,
                      todayProfitState,
                      transactionCountState,
                      lowStockCountState,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: RecentActivity()),
                        const SizedBox(width: 24),
                        Expanded(child: QuickActions()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Refresh status bar with last updated time
  Widget _buildRefreshBar(BuildContext context) {
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
            Icon(
              Icons.sync,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Last updated: $timeAgo',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: 'Refresh dashboard',
          onPressed: _refreshDashboard,
          iconSize: 20,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: const EdgeInsets.all(6),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.dashboard_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Here\'s what\'s happening with your store today',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
  ) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _buildMetricCardAsync(
          title: 'Today\'s Sales',
          state: salesState,
          format: (v) => CurrencyFormatter.format(v),
          icon: Icons.trending_up,
        ),
        _buildMetricCardAsync(
          title: 'Total Profit',
          state: profitState,
          format: (v) => CurrencyFormatter.format(v),
          icon: Icons.account_balance_wallet_outlined,
        ),
        _buildMetricCardAsyncInt(
          title: 'Transactions',
          state: transactionState,
          icon: Icons.receipt_long_outlined,
        ),
        _buildMetricCardAsyncInt(
          title: 'Low Stock Items',
          state: lowStockState,
          icon: Icons.inventory_2_outlined,
        ),
      ],
    );
  }

  Widget _buildMetricCardAsync({
    required String title,
    required AsyncValue<double> state,
    required String Function(double) format,
    required IconData icon,
  }) {
    return state.when(
      data: (value) => MetricCard(
        title: title,
        value: format(value),
        change: '',
        isPositive: true,
        icon: icon,
      ),
      loading: () => MetricCard(
        title: title,
        value: '—',
        change: 'Loading...',
        isPositive: true,
        icon: icon,
      ),
      error: (error, stackTrace) => MetricCard(
        title: title,
        value: '—',
        change: 'Error',
        isPositive: false,
        icon: icon,
      ),
    );
  }

  Widget _buildMetricCardAsyncInt({
    required String title,
    required AsyncValue<int> state,
    required IconData icon,
  }) {
    return state.when(
      data: (value) => MetricCard(
        title: title,
        value: value.toString(),
        change: '',
        isPositive: true,
        icon: icon,
      ),
      loading: () => MetricCard(
        title: title,
        value: '—',
        change: 'Loading...',
        isPositive: true,
        icon: icon,
      ),
      error: (error, stackTrace) => MetricCard(
        title: title,
        value: '—',
        change: 'Error',
        isPositive: false,
        icon: icon,
      ),
    );
  }
}
