import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_constants.dart';
import 'package:pasal_pro/core/theme/app_theme.dart';
import 'package:pasal_pro/core/widgets/app_navigation_rail.dart';
import 'package:pasal_pro/core/widgets/pasal_pro_appbar.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/utils/app_logger.dart';
import 'package:pasal_pro/core/routes/app_routes.dart';
import 'package:pasal_pro/core/routes/route_builder.dart';
import 'package:pasal_pro/features/settings/presentation/providers/theme_providers.dart';
import 'package:pasal_pro/features/settings/presentation/providers/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.info(
    'Starting ${AppConstants.appName} v${AppConstants.appVersion}',
  );

  runApp(const ProviderScope(child: PasalProApp()));
}

class PasalProApp extends ConsumerWidget {
  const PasalProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme mode from settings
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Modern flat design theme (not Material 3 defaults)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Home screen with desktop navigation
      home: const PasalProHome(),

      // Handle named route navigation
      onGenerateRoute: _handleRouteGeneration,
    );
  }

  /// Generate routes for named navigation
  /// Handles secondary routes like /customer-form, feature dialogs, etc.
  Route? _handleRouteGeneration(RouteSettings settings) {
    // Map route names to pages
    // This handles secondary routes outside the main navigation rail
    switch (settings.name) {
      case AppRoutes.productForm:
        return MaterialPageRoute(builder: (_) => const PasalProHome());
      case AppRoutes.customerDetail:
        return MaterialPageRoute(builder: (_) => const PasalProHome());
      case AppRoutes.productDetail:
        return MaterialPageRoute(builder: (_) => const PasalProHome());
      // Default: show home
      default:
        return null;
    }
  }
}

/// Main home screen with desktop navigation rail
class PasalProHome extends ConsumerStatefulWidget {
  const PasalProHome({super.key});

  @override
  ConsumerState<PasalProHome> createState() => _PasalProHomeState();
}

enum _FooterPanel { none, settings, help, account }

class _PasalProHomeState extends ConsumerState<PasalProHome> {
  int _selectedIndex = 0;
  bool _railExpanded = true;
  String? _syncStatus;
  _FooterPanel _footerPanel = _FooterPanel.none;

  /// Map of main navigation routes with metadata
  late final List<NavRailDestination> _destinations = [
    NavRailDestination(
      label: AppRoutes.getRouteInfo(AppRoutes.dashboard).label,
      icon: Icons.dashboard,
      shortcut: AppRoutes.getRouteInfo(AppRoutes.dashboard).shortcut,
    ),
    NavRailDestination(
      label: AppRoutes.getRouteInfo(AppRoutes.dailySales).label,
      icon: Icons.shopping_cart,
      shortcut: AppRoutes.getRouteInfo(AppRoutes.dailySales).shortcut,
    ),
    NavRailDestination(
      label: AppRoutes.getRouteInfo(AppRoutes.products).label,
      icon: Icons.inventory_2,
      shortcut: AppRoutes.getRouteInfo(AppRoutes.products).shortcut,
    ),
    NavRailDestination(
      label: AppRoutes.getRouteInfo(AppRoutes.customers).label,
      icon: Icons.people,
      shortcut: AppRoutes.getRouteInfo(AppRoutes.customers).shortcut,
    ),
    NavRailDestination(
      label: AppRoutes.getRouteInfo(AppRoutes.cheques).label,
      icon: Icons.description,
      shortcut: AppRoutes.getRouteInfo(AppRoutes.cheques).shortcut,
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
        onThemeSelected: _handleThemeSelection,
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
            onSettingsSelected: _handleSettingsSelection,
            onHelpSelected: _handleHelpSelection,
            onAccountSelected: _handleAccountSelection,
            activeFooterLabel: _getActiveFooterLabel(),
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
    if (_footerPanel == _FooterPanel.settings) {
      return AppRoutes.getRouteInfo(AppRoutes.settings).label;
    }
    if (_footerPanel == _FooterPanel.help) {
      return 'HELP';
    }
    if (_footerPanel == _FooterPanel.account) {
      return 'ACCOUNT';
    }
    return _destinations[_selectedIndex].label;
  }

  /// Handle navigation rail selection
  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
      _footerPanel = _FooterPanel.none;
    });
    AppLogger.info('Navigated to: ${_destinations[index].label}');
  }

  void _handleSettingsSelection() {
    setState(() => _footerPanel = _FooterPanel.settings);
    AppLogger.info('Navigated to: SETTINGS');
  }

  void _handleHelpSelection() {
    setState(() => _footerPanel = _FooterPanel.help);
    AppLogger.info('Navigated to: HELP');
  }

  void _handleAccountSelection() {
    setState(() => _footerPanel = _FooterPanel.account);
    AppLogger.info('Navigated to: ACCOUNT');
  }

  Future<void> _handleThemeSelection(String mode) async {
    await ref.read(settingsNotifierProvider.notifier).setThemeMode(mode);
    AppLogger.info('Theme changed to: $mode');
  }

  String? _getActiveFooterLabel() {
    return switch (_footerPanel) {
      _FooterPanel.settings => 'SETTINGS',
      _FooterPanel.help => 'HELP',
      _FooterPanel.account => 'ACCOUNT',
      _FooterPanel.none => null,
    };
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
    switch (_footerPanel) {
      case _FooterPanel.settings:
        return RouteBuilder.buildContent(AppRoutes.settings);
      case _FooterPanel.help:
        return const _HelpPageContent();
      case _FooterPanel.account:
        return const _AccountPageContent();
      case _FooterPanel.none:
        break;
    }
    final routes = AppRoutes.getMainRoutes();
    if (_selectedIndex < 0 || _selectedIndex >= routes.length) {
      return RouteBuilder.buildContent(AppRoutes.dashboard);
    }
    return RouteBuilder.buildContent(routes[_selectedIndex]);
  }
}

class _HelpPageContent extends StatelessWidget {
  const _HelpPageContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          AppSpacing.medium,
          Text(
            'Help & Support',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          AppSpacing.xSmall,
          Text(
            'Help content will appear here.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AccountPageContent extends StatelessWidget {
  const _AccountPageContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          AppSpacing.medium,
          Text('Account', style: Theme.of(context).textTheme.headlineSmall),
          AppSpacing.xSmall,
          Text(
            'Account details will appear here.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
