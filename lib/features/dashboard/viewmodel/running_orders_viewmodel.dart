import 'package:flutter/foundation.dart';
import '../model/order_category_model.dart';

/// ViewModel for the Running Orders screen
class RunningOrdersViewModel extends ChangeNotifier {
  String _selectedOutlet = 'All Outlets';
  int _selectedTabIndex = 0;
  List<OrderCategoryModel> _orderCategories = [];
  
  RunningOrdersViewModel() {
    _orderCategories = OrderCategoryModel.getDefaultCategories();
  }

  String get selectedOutlet => _selectedOutlet;
  int get selectedTabIndex => _selectedTabIndex;
  List<OrderCategoryModel> get orderCategories => _orderCategories;

  /// Get total order count across all categories
  int get totalOrderCount {
    return _orderCategories.fold(0, (sum, category) => sum + category.orderCount);
  }

  /// Get total estimated amount across all categories
  double get totalEstimatedAmount {
    return _orderCategories.fold(0.0, (sum, category) => sum + category.estimatedAmount);
  }

  /// Update selected outlet
  void setSelectedOutlet(String outlet) {
    _selectedOutlet = outlet;
    notifyListeners();
  }

  /// Update selected tab index
  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  /// Refresh order data
  void refreshOrders() {
    // TODO: Implement API call to fetch updated orders
    notifyListeners();
  }
}
