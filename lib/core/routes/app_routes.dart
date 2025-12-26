import 'package:flutter/material.dart';
import '../../features/dashboard/view/pages/dashboard_page.dart';
import '../../features/dashboard/view/pages/notification_page.dart';
import '../../features/more/view/pages/menu_and_store_page.dart';
import '../../features/more/view/pages/online_orders_page.dart';
import '../../features/more/view/pages/pending_purchase_page.dart';
import '../../features/more/view/pages/running_orders_page.dart';
import '../../features/more/view/pages/store_status_tracking_page.dart';

/// Centralized route names for the entire app
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Route names matching drawer menu item IDs
  static const String dashboard = 'dashboard';
  static const String runningOrders = 'running_orders';
  static const String onlineOrders = 'online_orders';
  static const String menuStoreActions = 'menu_store_actions';
  static const String storeStatusTracking = 'store_status_tracking';
  static const String thirdpartyConfig = 'thirdparty_config';
  static const String pendingPurchases = 'pending_purchases';
  static const String notification = 'notification';

  /// Map of route names to their corresponding page widgets
  /// This makes navigation scalable - just add entries here for new pages
  static final Map<String, WidgetBuilder> routes = {
    dashboard: (_) => const DashboardPage(),
    runningOrders: (_) => const RunningOrdersPage(),
    onlineOrders: (_) => const OnlineOrdersPage(),
    menuStoreActions: (_) => const MenuAndStorePage(),
    thirdpartyConfig: (_) => const MenuAndStorePage(),
    storeStatusTracking: (_) => const StoreStatusTrackingPage(),
    pendingPurchases: (_) => const PendingPurchasePage(),
    notification: (_) => const NotificationPage(),
  };

  /// Check if a route exists
  static bool hasRoute(String routeName) => routes.containsKey(routeName);

  /// Get the widget for a route
  static Widget? getPage(String routeName, BuildContext context) {
    final builder = routes[routeName];
    return builder?.call(context);
  }
}
