import 'package:flutter/foundation.dart';

/// ViewModel for Admin Group Management page
class AdminGroupViewModel extends ChangeNotifier {
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

  // Admin Group Name filter
  String _adminGroupName = '';

  String get adminGroupName => _adminGroupName;

  void setAdminGroupName(String name) {
    _adminGroupName = name;
    notifyListeners();
  }

  // Admin groups list (empty for now - will be populated from API)
  List<Map<String, dynamic>> _adminGroups = [];

  List<Map<String, dynamic>> get adminGroups => _adminGroups;

  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Search functionality
  void search() {
    _isLoading = true;
    notifyListeners();

    // TODO: Implement API call to search admin groups
    // For now, just simulate a search
    Future.delayed(const Duration(milliseconds: 500), () {
      _adminGroups = []; // Results would come from API
      _isLoading = false;
      notifyListeners();
    });
  }

  void showAll() {
    _adminGroupName = '';
    search();
  }

  void clearFilters() {
    _adminGroupName = '';
    notifyListeners();
  }
}
