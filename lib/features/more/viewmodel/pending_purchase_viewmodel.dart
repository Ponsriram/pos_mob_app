import 'package:flutter/material.dart';
import '../model/pending_purchase_model.dart';

/// ViewModel for the Pending Purchase page
class PendingPurchaseViewModel extends ChangeNotifier {
  // State
  String _selectedOutlet = 'All Outlets';
  String _selectedRestaurant = 'Aarthi cake Magic';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;
  List<PendingPurchaseModel> _purchases = [];

  // Available options
  final List<String> _outlets = ['All Outlets', 'Outlet 1', 'Outlet 2'];
  final List<String> _restaurants = [
    'Aarthi cake Magic',
    'Restaurant 1',
    'Restaurant 2',
  ];

  // Getters
  String get selectedOutlet => _selectedOutlet;
  String get selectedRestaurant => _selectedRestaurant;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  bool get isLoading => _isLoading;
  List<PendingPurchaseModel> get purchases => _purchases;
  List<String> get outlets => _outlets;
  List<String> get restaurants => _restaurants;
  bool get isEmpty => _purchases.isEmpty;

  // Setters
  void setSelectedOutlet(String outlet) {
    if (_selectedOutlet != outlet) {
      _selectedOutlet = outlet;
      notifyListeners();
    }
  }

  void setSelectedRestaurant(String restaurant) {
    if (_selectedRestaurant != restaurant) {
      _selectedRestaurant = restaurant;
      notifyListeners();
    }
  }

  void setStartDate(DateTime date) {
    if (_startDate != date) {
      _startDate = date;
      notifyListeners();
    }
  }

  void setEndDate(DateTime date) {
    if (_endDate != date) {
      _endDate = date;
      notifyListeners();
    }
  }

  // Actions
  Future<void> search() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For now, return empty list (no data)
      _purchases = [];
    } catch (e) {
      // Handle error
      _purchases = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> showAll() async {
    // Reset filters
    _selectedRestaurant = _restaurants.first;
    _startDate = DateTime.now().subtract(const Duration(days: 30));
    _endDate = DateTime.now();

    await search();
  }

  void reset() {
    _selectedOutlet = 'All Outlets';
    _selectedRestaurant = _restaurants.first;
    _startDate = DateTime.now().subtract(const Duration(days: 7));
    _endDate = DateTime.now();
    _purchases = [];
    _isLoading = false;
    notifyListeners();
  }
}
