import 'package:flutter/material.dart';
import '../model/dashboard_stats_model.dart';
import '../model/outlet_stats_model.dart';

/// ViewModel for the Dashboard screen
/// Manages state and business logic for the dashboard
class DashboardViewModel extends ChangeNotifier {
  // Private state
  DateTime _selectedDate = DateTime.now();
  String _selectedOutlet = 'All Outlets';
  int _activeStatsTab = 0;
  int _currentNavIndex = 0;
  bool _isDrawerOpen = false;

  // Getters
  DateTime get selectedDate => _selectedDate;
  String get selectedOutlet => _selectedOutlet;
  int get activeStatsTab => _activeStatsTab;
  int get currentNavIndex => _currentNavIndex;
  bool get isDrawerOpen => _isDrawerOpen;

  /// Get formatted date string for display
  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = _selectedDate.day;
    final suffix = _getDaySuffix(day);
    final month = months[_selectedDate.month - 1];
    return '$day$suffix $month';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Static data for UI - Dashboard stats
  DashboardStatsModel get stats => DashboardStatsModel.sample();

  /// Static data for UI - Outlet statistics
  List<OutletStatsModel> get outletStats => OutletStatsModel.getSampleData();

  /// List of available outlets
  List<String> get availableOutlets => [
    'All Outlets',
    'Aarthi cake Magic',
    'Ambattur Aarthi sweets and bakery',
  ];

  /// Stats tab labels
  List<String> get statsTabLabels => [
    'Orders',
    'Sales',
    'Net Sales',
    'Tax',
    'Discounts',
    'Modified',
    'Re-print',
  ];

  // Actions
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedOutlet(String outlet) {
    _selectedOutlet = outlet;
    notifyListeners();
  }

  void setActiveStatsTab(int index) {
    _activeStatsTab = index;
    notifyListeners();
  }

  void setCurrentNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  void openDrawer() {
    _isDrawerOpen = true;
    notifyListeners();
  }

  void closeDrawer() {
    _isDrawerOpen = false;
    notifyListeners();
  }

  /// Get the value for a specific outlet based on the active tab
  String getOutletValue(OutletStatsModel outlet) {
    switch (_activeStatsTab) {
      case 0: // Orders
        return outlet.orders.toString();
      case 1: // Sales
        return outlet.sales.toStringAsFixed(2);
      case 2: // Net Sales
        return outlet.netSales.toStringAsFixed(2);
      case 3: // Tax
        return outlet.tax.toStringAsFixed(2);
      case 4: // Discounts
        return outlet.discounts.toStringAsFixed(2);
      case 5: // Modified
        return outlet.modified.toString();
      case 6: // Re-print
        return outlet.reprint.toString();
      default:
        return outlet.orders.toString();
    }
  }

  /// Get the column header based on active tab
  String get activeTabColumnHeader => statsTabLabels[_activeStatsTab];
}
