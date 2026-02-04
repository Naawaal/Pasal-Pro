import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/customers/presentation/pages/customers_page.dart';
import 'package:pasal_pro/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:pasal_pro/features/products/presentation/pages/products_page.dart';
import 'package:pasal_pro/features/sales/presentation/pages/fast_sale_page.dart';
import 'package:pasal_pro/features/settings/presentation/pages/settings_page.dart';

/// Quick action buttons with real store statistics
class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeStatsAsync = ref.watch(storeStatsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          _buildActionButton(
            context,
            icon: Icons.add_shopping_cart,
            label: 'New Sale',
            subtitle: 'Record a transaction',
            badgeLabel: '⌘+S',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _FeaturePageWrapper(
                  title: 'New Sale',
                  child: const FastSalePage(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.inventory_2,
            label: 'Products',
            subtitle: 'Manage inventory',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _FeaturePageWrapper(
                  title: 'Products',
                  child: const ProductsPage(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.people,
            label: 'Customers',
            subtitle: 'View & manage customers',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _FeaturePageWrapper(
                  title: 'Customers',
                  child: const CustomersPage(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.settings,
            label: 'Settings',
            subtitle: 'App configuration',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _FeaturePageWrapper(
                  title: 'Settings',
                  child: const SettingsPage(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 20),
          // Store stats
          Text(
            'Today\'s Stats',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          storeStatsAsync.when(
            loading: () => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            error: (error, stack) => Text(
              'Failed to load stats',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            data: (stats) => Column(
              children: [
                _buildStatRow(
                  context,
                  'Sales',
                  CurrencyFormatter.format(stats.todaySalesAmount),
                  Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  context,
                  'Profit',
                  CurrencyFormatter.format(stats.todayProfit),
                  Colors.green,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  context,
                  'Transactions',
                  '${stats.todayTransactions}',
                  Colors.purple,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  context,
                  'Low Stock',
                  '${stats.lowStockCount}',
                  Colors.amber,
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  context,
                  'Outstanding',
                  CurrencyFormatter.format(stats.outstandingCredit),
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    String? badgeLabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Wrapper widget to provide Material context for feature pages
/// Includes AppBar with back button for navigation
class _FeaturePageWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const _FeaturePageWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: child,
    );
  }
}
