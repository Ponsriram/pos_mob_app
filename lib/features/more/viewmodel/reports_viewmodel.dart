import 'package:flutter/foundation.dart';
import '../model/report_model.dart';

/// ViewModel for the Reports screen
class ReportsViewModel extends ChangeNotifier {
  String _selectedOutlet = 'All Outlets';
  String _searchQuery = '';
  List<ReportModel> _reports = [];
  List<ReportModel> _filteredReports = [];

  ReportsViewModel() {
    _reports = ReportModel.getDefaultReports();
    _filteredReports = _reports;
  }

  // Getters
  String get selectedOutlet => _selectedOutlet;
  String get searchQuery => _searchQuery;
  List<ReportModel> get filteredReports => _filteredReports;

  /// List of available outlets
  List<String> get availableOutlets => [
    'All Outlets',
    'Aarthi cake Magic',
    'Ambattur Aarthi sweets and bakery',
  ];

  /// Get favorite reports
  List<ReportModel> get favoriteReports =>
      _reports.where((report) => report.isFavorite).toList();

  /// Get reports grouped by category
  Map<String, List<ReportModel>> get groupedReports {
    final Map<String, List<ReportModel>> grouped = {};
    for (final report in _filteredReports) {
      if (!grouped.containsKey(report.category)) {
        grouped[report.category] = [];
      }
      grouped[report.category]!.add(report);
    }
    return grouped;
  }

  // Setters
  void setSelectedOutlet(String outlet) {
    if (_selectedOutlet != outlet) {
      _selectedOutlet = outlet;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterReports();
    notifyListeners();
  }

  void toggleFavorite(String reportId) {
    final index = _reports.indexWhere((report) => report.id == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(
        isFavorite: !_reports[index].isFavorite,
      );
      _filterReports();
      notifyListeners();
    }
  }

  void _filterReports() {
    if (_searchQuery.isEmpty) {
      _filteredReports = _reports;
    } else {
      _filteredReports = _reports.where((report) {
        return report.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            report.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }
  }
}
