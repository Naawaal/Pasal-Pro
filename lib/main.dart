import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_constants.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/theme/app_theme.dart';
import 'package:pasal_pro/features/products/presentation/pages/products_page.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.info(
    'Starting ${AppConstants.appName} v${AppConstants.appVersion}',
  );

  runApp(const ProviderScope(child: PasalProApp()));
}

class PasalProApp extends StatelessWidget {
  const PasalProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Material 3 theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Home screen (temporary)
      home: const ProductsPage(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(AppIcons.settings),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo using Lucide icon
            Icon(
              AppIcons.store,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            AppSpacing.large,

            // App title
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            AppSpacing.xSmall,

            // Tagline
            Text(
              AppConstants.appTagline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.xxLarge,

            // Status card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Padding(
                padding: AppSpacing.paddingLarge,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(AppIcons.rocket, size: 20),
                        AppSpacing.hXSmall,
                        Text(
                          'Development in Progress',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    AppSpacing.medium,
                    _buildStatusItem(
                      context,
                      AppIcons.database,
                      'Database Models',
                    ),
                    AppSpacing.xSmall,
                    _buildStatusItem(context, AppIcons.palette, 'Theme System'),
                    AppSpacing.xSmall,
                    _buildStatusItem(
                      context,
                      AppIcons.shield,
                      'Error Handling',
                    ),
                    AppSpacing.xSmall,
                    _buildStatusItem(context, AppIcons.wrench, 'Utilities'),
                    AppSpacing.large,
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppIcons.forward,
                            size: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          AppSpacing.hXSmall,
                          Text(
                            'Next: Product Management',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(AppIcons.checkCircle, size: 16, color: AppTheme.profitColor),
        AppSpacing.hXSmall,
        Icon(icon, size: 16),
        AppSpacing.hXSmall,
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
