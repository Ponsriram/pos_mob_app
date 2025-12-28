import 'package:flutter/foundation.dart';

/// ViewModel for Cloud Access page
class CloudAccessViewModel extends ChangeNotifier {
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

  // Name filter
  String _name = '';

  String get name => _name;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  // Email filter
  String _email = '';

  String get email => _email;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  // Select Type filter
  String _selectedType = 'All';
  final List<String> _types = ['All', 'Franchise Owner', 'Restaurant User'];

  String get selectedType => _selectedType;
  List<String> get types => _types;

  void setSelectedType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  // Select Status filter
  String _selectedStatus = 'Active';
  final List<String> _statuses = ['All', 'Active', 'Inactive'];

  String get selectedStatus => _selectedStatus;
  List<String> get statuses => _statuses;

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  // Cloud access users list (empty for now - will be populated from API)
  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get users => _users;

  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Search functionality
  void search() {
    _isLoading = true;
    notifyListeners();

    // TODO: Implement API call to search cloud access users
    // For now, just simulate a search
    Future.delayed(const Duration(milliseconds: 500), () {
      _users = []; // Results would come from API
      _isLoading = false;
      notifyListeners();
    });
  }

  void showAll() {
    _name = '';
    _email = '';
    _selectedType = 'All';
    _selectedStatus = 'Active';
    search();
  }

  void clearFilters() {
    _name = '';
    _email = '';
    _selectedType = 'All';
    _selectedStatus = 'Active';
    notifyListeners();
  }

  // Action dropdown for bulk actions
  void setActiveStatus() {
    // TODO: Implement bulk set active
  }

  void setInactiveStatus() {
    // TODO: Implement bulk set inactive
  }
}
