import 'package:flutter/foundation.dart';
import '../model/online_order_model.dart';

/// ViewModel for the Online Orders Activity screen
class OnlineOrdersViewModel extends ChangeNotifier {
  String _selectedOutlet = 'All Outlets';
  String _selectedPlatformId = 'all';
  RestaurantModel? _selectedRestaurant;
  RecordType _selectedRecordType = RecordType.last2DaysRecords;
  OrderStatus _selectedStatus = OrderStatus.all;
  String _orderNoFilter = '';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();
  bool _isChartExpanded = false;
  bool _isLoading = false;
  List<OnlineOrderModel> _orders = [];
  List<RestaurantModel> _restaurants = [];
  List<OrderPlatformModel> _platforms = [];

  OnlineOrdersViewModel() {
    _restaurants = RestaurantModel.getDefaultRestaurants();
    _platforms = OrderPlatformModel.getDefaultPlatforms();
    if (_restaurants.isNotEmpty) {
      _selectedRestaurant = _restaurants.first;
    }
  }

  // Getters
  String get selectedOutlet => _selectedOutlet;
  String get selectedPlatformId => _selectedPlatformId;
  RestaurantModel? get selectedRestaurant => _selectedRestaurant;
  RecordType get selectedRecordType => _selectedRecordType;
  OrderStatus get selectedStatus => _selectedStatus;
  String get orderNoFilter => _orderNoFilter;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  bool get isChartExpanded => _isChartExpanded;
  bool get isLoading => _isLoading;
  List<OnlineOrderModel> get orders => _orders;
  List<RestaurantModel> get restaurants => _restaurants;
  List<OrderPlatformModel> get platforms => _platforms;

  /// Check if date range fields should be shown
  bool get showDateRange => _selectedRecordType == RecordType.getOldRecords;

  /// Get filtered orders count
  int get filteredOrdersCount => _orders.length;

  /// Update selected outlet
  void setSelectedOutlet(String outlet) {
    _selectedOutlet = outlet;
    notifyListeners();
  }

  /// Update selected platform
  void setSelectedPlatform(String platformId) {
    _selectedPlatformId = platformId;
    notifyListeners();
  }

  /// Update selected restaurant
  void setSelectedRestaurant(RestaurantModel? restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }

  /// Update selected record type
  void setSelectedRecordType(RecordType recordType) {
    _selectedRecordType = recordType;
    notifyListeners();
  }

  /// Update selected status
  void setSelectedStatus(OrderStatus status) {
    _selectedStatus = status;
    notifyListeners();
  }

  /// Update order number filter
  void setOrderNoFilter(String orderNo) {
    _orderNoFilter = orderNo;
    notifyListeners();
  }

  /// Update start date
  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  /// Update end date
  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  /// Toggle chart expansion
  void toggleChartExpansion() {
    _isChartExpanded = !_isChartExpanded;
    notifyListeners();
  }

  /// Apply filters and fetch orders
  Future<void> applyFilters() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch orders with filters
      await Future.delayed(const Duration(milliseconds: 500));
      _orders = []; // Replace with actual API response
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset all filters and show all orders
  void showAll() {
    _selectedPlatformId = 'all';
    _selectedRecordType = RecordType.last2DaysRecords;
    _selectedStatus = OrderStatus.all;
    _orderNoFilter = '';
    _startDate = DateTime.now().subtract(const Duration(days: 1));
    _endDate = DateTime.now();
    applyFilters();
  }

  /// Refresh data
  Future<void> refresh() async {
    await applyFilters();
  }
}
