import 'package:flutter/foundation.dart';

/// ViewModel for Online Store Logs page
class OnlineStoreLogsViewModel extends ChangeNotifier {
  // Outlet selection
  String _selectedOutlet = 'All Outlets';
  final List<String> _availableOutlets = [
    'All Outlets',
    'Outlet 1',
    'Outlet 2',
  ];

  String get selectedOutlet => _selectedOutlet;
  List<String> get availableOutlets => _availableOutlets;

  void setSelectedOutlet(String outlet) {
    _selectedOutlet = outlet;
    notifyListeners();
  }

  // Search section expansion
  bool _isSearchExpanded = true;

  bool get isSearchExpanded => _isSearchExpanded;

  void toggleSearchExpanded() {
    _isSearchExpanded = !_isSearchExpanded;
    notifyListeners();
  }

  // Select Restaurant filter (multi-select with checkboxes)
  final List<String> _restaurants = [
    'Please Select',
    '363317 - Aarthi cake Magic',
    '383514 - Ambattur Aarthi sweets and bakery',
  ];
  final Set<String> _selectedRestaurants = {};

  List<String> get restaurants => _restaurants;
  Set<String> get selectedRestaurants => _selectedRestaurants;

  bool get isAllRestaurantsSelected => _selectedRestaurants.isEmpty;

  void toggleAllRestaurants() {
    if (_selectedRestaurants.isEmpty) {
      // Select all restaurants (except "Please Select")
      _selectedRestaurants.addAll(
        _restaurants.where((r) => r != 'Please Select'),
      );
    } else {
      // Deselect all
      _selectedRestaurants.clear();
    }
    notifyListeners();
  }

  void toggleRestaurant(String restaurant) {
    if (_selectedRestaurants.contains(restaurant)) {
      _selectedRestaurants.remove(restaurant);
    } else {
      _selectedRestaurants.add(restaurant);
    }
    notifyListeners();
  }

  String get restaurantDisplayText {
    if (_selectedRestaurants.isEmpty) {
      return 'All';
    }
    if (_selectedRestaurants.length == 1) {
      return _selectedRestaurants.first;
    }
    return '${_selectedRestaurants.length} restaurants selected';
  }

  // From Date filter
  DateTime? _fromDate = DateTime.now();

  DateTime? get fromDate => _fromDate;

  void setFromDate(DateTime? date) {
    _fromDate = date;
    notifyListeners();
  }

  // To Date filter
  DateTime? _toDate = DateTime.now();

  DateTime? get toDate => _toDate;

  void setToDate(DateTime? date) {
    _toDate = date;
    notifyListeners();
  }

  // Select Outlet filter
  String _selectedOutletFilter = 'Select Outlet';
  final List<String> _outlets = [
    'Select Outlet',
    'Outlet 1',
    'Outlet 2',
    'Outlet 3',
  ];

  String get selectedOutletFilter => _selectedOutletFilter;
  List<String> get outlets => _outlets;

  void setSelectedOutletFilter(String outlet) {
    _selectedOutletFilter = outlet;
    notifyListeners();
  }

  // Logs list (empty for now - will be populated from API)
  List<Map<String, dynamic>> _logs = [];

  List<Map<String, dynamic>> get logs => _logs;

  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Search functionality
  void search() {
    _isLoading = true;
    notifyListeners();

    // TODO: Implement API call to search logs
    // For now, just simulate a search
    Future.delayed(const Duration(milliseconds: 500), () {
      _logs = []; // Results would come from API
      _isLoading = false;
      notifyListeners();
    });
  }

  void reset() {
    _selectedRestaurants.clear();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
    _selectedOutletFilter = 'Select Outlet';
    notifyListeners();
  }
}
