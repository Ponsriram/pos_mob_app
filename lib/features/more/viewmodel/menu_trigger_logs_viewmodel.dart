import 'package:flutter/foundation.dart';

/// ViewModel for Menu Trigger Logs page
class MenuTriggerLogsViewModel extends ChangeNotifier {
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

  // Select Restaurant filter
  String _selectedRestaurant = 'Please Select';
  final List<String> _restaurants = [
    'Please Select',
    '363317 - Aarthi cake Magic',
    '383514 - Ambattur Aarthi sweets and bakery',
  ];

  String get selectedRestaurant => _selectedRestaurant;
  List<String> get restaurants => _restaurants;

  void setSelectedRestaurant(String restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }

  // From Date filter
  DateTime? _fromDate;

  DateTime? get fromDate => _fromDate;

  void setFromDate(DateTime? date) {
    _fromDate = date;
    notifyListeners();
  }

  // To Date filter
  DateTime? _toDate;

  DateTime? get toDate => _toDate;

  void setToDate(DateTime? date) {
    _toDate = date;
    notifyListeners();
  }

  // Select Thirdparty User filter
  String _selectedThirdpartyUser = 'Select Thirdparty User';
  final List<String> _thirdpartyUsers = [
    'Select Thirdparty User',
    'Swiggy',
    'PayTM',
    'Ewards Online',
    'Dineout Ordering',
    'Dotpe',
    'Dukaan',
    'Menu QR',
  ];

  String get selectedThirdpartyUser => _selectedThirdpartyUser;
  List<String> get thirdpartyUsers => _thirdpartyUsers;

  void setSelectedThirdpartyUser(String user) {
    _selectedThirdpartyUser = user;
    notifyListeners();
  }

  // Client Restaurant ID filter
  String _clientRestaurantId = '';

  String get clientRestaurantId => _clientRestaurantId;

  void setClientRestaurantId(String id) {
    _clientRestaurantId = id;
    notifyListeners();
  }

  // Request Id filter
  String _requestId = '';

  String get requestId => _requestId;

  void setRequestId(String id) {
    _requestId = id;
    notifyListeners();
  }

  // Status filter
  String _selectedStatus = 'All';
  final List<String> _statuses = ['All', 'Success', 'Failed', 'In Process'];

  String get selectedStatus => _selectedStatus;
  List<String> get statuses => _statuses;

  void setSelectedStatus(String status) {
    _selectedStatus = status;
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
    _selectedRestaurant = 'Please Select';
    _fromDate = null;
    _toDate = null;
    _selectedThirdpartyUser = 'Select Thirdparty User';
    _clientRestaurantId = '';
    _requestId = '';
    _selectedStatus = 'All';
    notifyListeners();
  }
}
