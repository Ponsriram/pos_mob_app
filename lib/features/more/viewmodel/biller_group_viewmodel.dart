import 'package:flutter/foundation.dart';

/// ViewModel for Biller Group Management page
class BillerGroupViewModel extends ChangeNotifier {
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

  // Biller Group Name filter
  String _billerGroupName = '';

  String get billerGroupName => _billerGroupName;

  void setBillerGroupName(String name) {
    _billerGroupName = name;
    notifyListeners();
  }

  // User Type filter
  String _selectedUserType = 'All';
  final List<String> _userTypes = ['All', 'Billing User', 'Captain'];

  String get selectedUserType => _selectedUserType;
  List<String> get userTypes => _userTypes;

  void setSelectedUserType(String type) {
    _selectedUserType = type;
    notifyListeners();
  }

  // Biller groups list (empty for now - will be populated from API)
  List<Map<String, dynamic>> _billerGroups = [];

  List<Map<String, dynamic>> get billerGroups => _billerGroups;

  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Search functionality
  void search() {
    _isLoading = true;
    notifyListeners();

    // TODO: Implement API call to search biller groups
    // For now, just simulate a search
    Future.delayed(const Duration(milliseconds: 500), () {
      _billerGroups = []; // Results would come from API
      _isLoading = false;
      notifyListeners();
    });
  }

  void showAll() {
    _billerGroupName = '';
    _selectedUserType = 'All';
    search();
  }

  void clearFilters() {
    _billerGroupName = '';
    _selectedUserType = 'All';
    notifyListeners();
  }
}
