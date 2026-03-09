import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/store_provider.dart';
import 'package:pos_app/core/providers/repository_providers.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/report_repository.dart';
import '../model/report_model.dart';

part 'reports_viewmodel.g.dart';

/// State for the Reports screen
class ReportsState {
  final String? selectedStoreId;
  final String searchQuery;
  final List<ReportModel> reports;
  final List<ReportModel> filteredReports;
  final List<StoreModel> stores;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.selectedStoreId,
    this.searchQuery = '',
    this.reports = const [],
    this.filteredReports = const [],
    this.stores = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    String? selectedStoreId,
    String? searchQuery,
    List<ReportModel>? reports,
    List<ReportModel>? filteredReports,
    List<StoreModel>? stores,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      searchQuery: searchQuery ?? this.searchQuery,
      reports: reports ?? this.reports,
      filteredReports: filteredReports ?? this.filteredReports,
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// List of available outlets including "All Outlets"
  List<String> get availableOutlets => [
    'All Outlets',
    ...stores.map((s) => s.name),
  ];

  /// Get selected outlet name
  String get selectedOutletName {
    if (selectedStoreId == null) return 'All Outlets';
    final store = stores.where((s) => s.id == selectedStoreId).firstOrNull;
    return store?.name ?? 'All Outlets';
  }

  /// Alias for selectedOutletName
  String get selectedOutlet => selectedOutletName;

  /// Get favorite reports
  List<ReportModel> get favoriteReports =>
      reports.where((report) => report.isFavorite).toList();

  /// Get reports grouped by category
  Map<String, List<ReportModel>> get groupedReports {
    final Map<String, List<ReportModel>> grouped = {};
    for (final report in filteredReports) {
      if (!grouped.containsKey(report.category)) {
        grouped[report.category] = [];
      }
      grouped[report.category]!.add(report);
    }
    return grouped;
  }
}

/// ViewModel for the Reports screen using Riverpod
@riverpod
class ReportsViewModel extends _$ReportsViewModel {
  late ReportRepository _reportRepo;

  @override
  ReportsState build() {
    _reportRepo = ref.watch(reportRepositoryProvider);
    // Watch the global store state
    final storeState = ref.watch(globalStoreNotifierProvider);

    _loadReportTemplates();

    return ReportsState(
      stores: storeState.stores,
      selectedStoreId: storeState.selectedStoreId,
    );
  }

  Future<void> _loadReportTemplates() async {
    state = state.copyWith(isLoading: true);
    final result = await _reportRepo.getReportTemplates();
    result.fold(
      (failure) {
        // Fallback to hardcoded defaults if API fails
        final defaultReports = ReportModel.getDefaultReports();
        state = state.copyWith(
          reports: defaultReports,
          filteredReports: defaultReports,
          isLoading: false,
        );
      },
      (templates) {
        state = state.copyWith(
          reports: templates,
          filteredReports: templates,
          isLoading: false,
        );
      },
    );
  }

  void setSelectedOutlet(String outletName) {
    // Update the global store provider
    ref
        .read(globalStoreNotifierProvider.notifier)
        .setSelectedOutlet(outletName);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _filterReports();
  }

  void toggleFavorite(String reportId) {
    final updatedReports = state.reports.map((report) {
      if (report.id == reportId) {
        return report.copyWith(isFavorite: !report.isFavorite);
      }
      return report;
    }).toList();

    state = state.copyWith(reports: updatedReports);
    _filterReports();
  }

  void _filterReports() {
    if (state.searchQuery.isEmpty) {
      state = state.copyWith(filteredReports: state.reports);
    } else {
      final filtered = state.reports.where((report) {
        return report.title.toLowerCase().contains(
              state.searchQuery.toLowerCase(),
            ) ||
            report.description.toLowerCase().contains(
              state.searchQuery.toLowerCase(),
            );
      }).toList();
      state = state.copyWith(filteredReports: filtered);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
