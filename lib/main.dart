import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_constants.dart';
import 'package:pasal_pro/core/theme/app_theme.dart';
import 'package:pasal_pro/core/widgets/app_navigation_rail.dart';
import 'package:pasal_pro/core/widgets/pasal_pro_appbar.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/sales/presentation/pages/fast_sale_page.dart';

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

      // Modern flat design theme (not Material 3 defaults)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Home screen with desktop navigation
      home: const PasalProHome(),
    );
  }
}

/// Main home screen with desktop navigation rail
class PasalProHome extends StatefulWidget {
  const PasalProHome({super.key});

  @override
  State<PasalProHome> createState() => _PasalProHomeState();
}

class _PasalProHomeState extends State<PasalProHome> {
  int _selectedIndex = 0;
  bool _railExpanded = true;
  String? _syncStatus;

  final List<NavRailDestination> _destinations = [
    const NavRailDestination(
      label: 'DAILY SALES',
      icon: Icons.shopping_cart,
      shortcut: 'F1',
    ),
    const NavRailDestination(
      label: 'DASHBOARD',
      icon: Icons.dashboard,
      shortcut: 'F2',
    ),
    const NavRailDestination(
      label: 'PRODUCTS',
      icon: Icons.inventory_2,
      shortcut: 'F3',
    ),
    const NavRailDestination(
      label: 'CUSTOMERS',
      icon: Icons.people,
      shortcut: 'F4',
    ),
    const NavRailDestination(
      label: 'CHEQUES',
      icon: Icons.description,
      shortcut: 'F5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PasalProAppBar(
        title: _getScreenTitle(),
        onSearch: _handleSearch,
        onSync: _handleSync,
        syncStatus: _syncStatus,
        onUserMenu: _handleUserMenu,
      ),
      body: Row(
        children: [
          // Navigation Rail
          AppNavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _handleNavigation,
            destinations: _destinations,
            isExpanded: _railExpanded,
            onToggleExpanded: () {
              setState(() => _railExpanded = !_railExpanded);
            },
          ),

          // Main content area
          Expanded(
            child: Container(color: AppColors.bgLight, child: _buildContent()),
          ),
        ],
      ),
    );
  }

  /// Get screen title based on selected index
  String _getScreenTitle() {
    return _destinations[_selectedIndex].label;
  }

  /// Handle navigation rail selection
  void _handleNavigation(int index) {
    setState(() => _selectedIndex = index);
    AppLogger.info('Navigated to: ${_destinations[index].label}');
  }

  /// Handle search action
  void _handleSearch() {
    AppLogger.info('Search triggered');
    // TODO: Implement search
  }

  /// Handle sync action
  void _handleSync() {
    setState(() => _syncStatus = 'syncing');
    AppLogger.info('Sync started');

    // Simulate sync
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _syncStatus = 'synced');
      }
    });
  }

  /// Handle user menu
  void _handleUserMenu() {
    AppLogger.info('User menu opened');
    // TODO: Implement user menu
  }

  /// Build content based on selected index
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const FastSalePage();
      case 1:
        return const _PlaceholderScreen(title: 'Dashboard');
      case 2:
        return const _PlaceholderScreen(title: 'Products');
      case 3:
        return const _PlaceholderScreen(title: 'Customers');
      case 4:
        return const _PlaceholderScreen(title: 'Cheques');
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
