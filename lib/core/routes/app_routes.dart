import 'package:flutter/material.dart';
import 'package:pos_app/features/more/view/pages/franchise_management_page.dart';
import '../../features/dashboard/view/pages/dashboard_page.dart';
import '../../features/dashboard/view/pages/notification_page.dart';
import '../../features/more/view/pages/admin_group_page.dart';
import '../../features/more/view/pages/biller_group_page.dart';
import '../../features/more/view/pages/cloud_access_page.dart';
import '../../features/more/view/pages/create_zone_page.dart';
import '../../features/more/view/pages/delete_outlet_page.dart';
import '../../features/more/view/pages/item_out_of_stock_page.dart';
import '../../features/more/view/pages/menu_and_store_page.dart';
import '../../features/more/view/pages/menu_trigger_logs_page.dart';
import '../../features/more/view/pages/online_item_logs_page.dart';
import '../../features/more/view/pages/online_orders_page.dart';
import '../../features/more/view/pages/online_store_logs_page.dart';
import '../../features/more/view/pages/outlet_type_page.dart';
import '../../features/more/view/pages/pending_purchase_page.dart';
import '../../features/more/view/pages/reports_page.dart';
import '../../features/more/view/pages/running_orders_page.dart';
import '../../features/more/view/pages/store_status_tracking_page.dart';
import '../../features/more/view/pages/thirdparty_config_page.dart';
import '../../features/more/view/pages/user_info_page.dart';

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
  static const String itemOutOfStock = 'item_out_of_stock';
  static const String thirdpartyConfig = 'thirdparty_config';
  static const String outletType = 'outlet_type';
  static const String pendingPurchases = 'pending_purchases';
  static const String notification = 'notification';
  static const String billerGroup = 'biller_group';
  static const String adminGroup = 'admin_group';
  static const String cloudAccess = 'cloud_access';
  static const String menuTriggerLogs = 'menu_trigger_logs';
  static const String onlineStoreLogs = 'online_store_logs';
  static const String onlineItemLogs = 'online_item_logs';
  static const String reports = 'reports';
  static const String franchiseManagement = 'franchise_management';
  static const String deleteOutlet = 'delete_outlet';
  static const String createZone = 'create_zone';
  static const String userInfo = 'user_info';
  static const String editProfile = 'edit_profile';

  /// Map of route names to their corresponding page widgets
  /// This makes navigation scalable - just add entries here for new pages
  static final Map<String, WidgetBuilder> routes = {
    dashboard: (_) => const DashboardPage(),
    runningOrders: (_) => const RunningOrdersPage(),
    onlineOrders: (_) => const OnlineOrdersPage(),
    menuStoreActions: (_) => const MenuAndStorePage(),
    thirdpartyConfig: (_) => const ThirdPartyConfigPage(),
    storeStatusTracking: (_) => const StoreStatusTrackingPage(),
    itemOutOfStock: (_) => const ItemOutOfStockPage(),
    outletType: (_) => const OutletTypePage(),
    pendingPurchases: (_) => const PendingPurchasePage(),
    notification: (_) => const NotificationPage(),
    billerGroup: (_) => const BillerGroupPage(),
    adminGroup: (_) => const AdminGroupPage(),
    cloudAccess: (_) => const CloudAccessPage(),
    menuTriggerLogs: (_) => const MenuTriggerLogsPage(),
    onlineStoreLogs: (_) => const OnlineStoreLogsPage(),
    onlineItemLogs: (_) => const OnlineItemLogsPage(),
    reports: (_) => const ReportsPage(),
    franchiseManagement: (_) => const FranchiseManagementPage(),
    deleteOutlet: (_) => const DeleteOutletPage(),
    createZone: (_) => const CreateZonePage(),
    userInfo: (_) => const UserInfoPage(),
    editProfile: (_) => const UserInfoPage(),
  };

  /// Check if a route exists
  static bool hasRoute(String routeName) => routes.containsKey(routeName);

  /// Get the widget for a route
  static Widget? getPage(String routeName, BuildContext context) {
    final builder = routes[routeName];
    return builder?.call(context);
  }
}
