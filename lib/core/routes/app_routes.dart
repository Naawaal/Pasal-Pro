// Application route definitions and navigation helpers
//
// This file centralizes all route names, making them easy to reference
// and maintain across the application.

abstract class AppRoutes {
  // Main navigation routes
  static const String dailySales = 'daily_sales';
  static const String dashboard = 'dashboard';
  static const String products = 'products';
  static const String customers = 'customers';
  static const String cheques = 'cheques';
  static const String settings = 'settings';

  // Feature routes
  static const String productForm = 'product_form';
  static const String productDetail = 'product_detail';
  static const String customerDetail = 'customer_detail';

  /// Get all main navigation routes in order
  static List<String> getMainRoutes() => [
    dashboard,
    dailySales,
    products,
    customers,
    cheques,
    settings,
  ];

  /// Get route icon and details
  static RouteInfo getRouteInfo(String route) {
    return _routeInfoMap[route] ??
        const RouteInfo(label: 'Unknown', icon: 0xe206, shortcut: '');
  }
}

/// Information about a route for navigation display
class RouteInfo {
  final String label;
  final int icon; // IconData codePoint
  final String shortcut;

  const RouteInfo({
    required this.label,
    required this.icon,
    required this.shortcut,
  });
}

/// Map of route information for easy lookup
const _routeInfoMap = {
  'dashboard': RouteInfo(
    label: 'DASHBOARD',
    icon: 0xe871, // dashboard
    shortcut: 'F1',
  ),
  'daily_sales': RouteInfo(
    label: 'DAILY SALES',
    icon: 0xf05c1, // shopping_cart
    shortcut: 'F2',
  ),
  'products': RouteInfo(
    label: 'PRODUCTS',
    icon: 0xf096, // inventory_2
    shortcut: 'F3',
  ),
  'customers': RouteInfo(
    label: 'CUSTOMERS',
    icon: 0xe7ef, // people
    shortcut: 'F4',
  ),
  'cheques': RouteInfo(
    label: 'CHEQUES',
    icon: 0xe8d7, // description
    shortcut: 'F5',
  ),
  'settings': RouteInfo(
    label: 'SETTINGS',
    icon: 0xe8b8, // settings
    shortcut: 'F6',
  ),
};
