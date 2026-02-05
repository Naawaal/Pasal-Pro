import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/customers/presentation/pages/customers_page.dart';
import 'package:pasal_pro/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:pasal_pro/features/products/presentation/pages/products_page.dart';
import 'package:pasal_pro/features/sales/presentation/pages/fast_sale_page.dart';
import 'package:pasal_pro/features/settings/presentation/pages/settings_page.dart';

/// Quick action buttons with real store statistics using Mix
class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeStatsAsync = ref.watch(storeStatsProvider);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);

    return Box(
      style: BoxStyler()
          .paddingAll(20.0)
          .borderRounded(12.0)
          .color(surfaceColor)
          .borderAll(color: borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledText(
            'Quick Actions',
            style: TextStyler()
                .fontSize(16)
                .fontWeight(FontWeight.w600)
                .color(textPrimary),
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
          Divider(color: borderColor),
          const SizedBox(height: 20),
          // Store stats
          StyledText(
            'Today\'s Stats',
            style: TextStyler()
                .fontSize(14)
                .fontWeight(FontWeight.w600)
                .color(textPrimary),
          ),
          const SizedBox(height: 12),
          storeStatsAsync.when(
            loading: () => Center(
              child: CircularProgressIndicator(
                color: PasalColorToken.primary.token.resolve(context),
              ),
            ),
            error: (error, stack) => Text(
              'Failed to load stats',
              style: TextStyle(color: PasalColorToken.error.token.resolve(context)),
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
    final borderColor = PasalColorToken.border.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return PressableBox(
      onPress: onTap,
      style: BoxStyler()
          .paddingAll(12.0)
          .borderRounded(8.0)
          .borderAll(color: borderColor)
          .onHovered(BoxStyler().color(surfaceHover)),
      child: Row(
        children: [
          Box(
            style: BoxStyler()
                .width(40)
                .height(40)
                .borderRounded(8.0)
                .color(primaryColor.withValues(alpha: 0.1)),
            child: StyledIcon(
              icon: icon,
              style: IconStyler().size(20).color(primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  label,
                  style: TextStyler()
                      .fontSize(14)
                      .fontWeight(FontWeight.w600)
                      .color(textPrimary),
                ),
                const SizedBox(height: 2),
                StyledText(
                  subtitle,
                  style: TextStyler().fontSize(11).color(textSecondary),
                ),
              ],
            ),
          ),
          if (badgeLabel != null)
            Box(
              style: BoxStyler()
                  .paddingX(6.0)
                  .paddingY(2.0)
                  .borderRounded(4.0)
                  .color(primaryColor.withValues(alpha: 0.15)),
              child: StyledText(
                badgeLabel,
                style: TextStyler()
                    .fontSize(10)
                    .fontWeight(FontWeight.w600)
                    .color(primaryColor),
              ),
            )
          else
            StyledIcon(
              icon: Icons.arrow_forward_ios,
              style: IconStyler().size(14).color(textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Box(
                style: BoxStyler()
                    .width(8)
                    .height(8)
                    .color(color)
                    .borderRounded(4.0),
                child: const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),
              StyledText(
                label,
                style: TextStyler().fontSize(13).color(textSecondary),
              ),
            ],
          ),
          StyledText(
            value,
            style: TextStyler()
                .fontSize(13)
                .fontWeight(FontWeight.w600)
                .color(textPrimary),
          ),
        ],
      ),
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


