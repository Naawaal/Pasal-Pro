import 'package:flutter/material.dart';
import 'package:pasal_pro/core/routes/app_routes.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/features/sales/presentation/pages/fast_sale_page.dart';
import 'package:pasal_pro/features/products/presentation/pages/products_page.dart';
import 'package:pasal_pro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:pasal_pro/features/customers/presentation/pages/customers_page.dart';
import 'package:pasal_pro/features/settings/presentation/pages/settings_page.dart';

/// Route builder class to handle content generation based on route name
class RouteBuilder {
  /// Build content widget for a given route
  static Widget buildContent(String route) {
    switch (route) {
      case AppRoutes.dailySales:
        return const FastSalePage();
      case AppRoutes.dashboard:
        return const DashboardPage();
      case AppRoutes.products:
        return const ProductsPage();
      case AppRoutes.customers:
        return const CustomersPage();
      case AppRoutes.cheques:
        return const _PlaceholderScreen(title: 'Cheques');
      case AppRoutes.settings:
        return const SettingsPage();
      default:
        return const _PlaceholderScreen(title: 'Home');
    }
  }
}

/// Placeholder screen for development
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: AppColors.textTertiary),
          AppSpacing.medium,
          Text(
            '$title Screen',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          AppSpacing.xSmall,
          Text(
            'Coming soon...',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
