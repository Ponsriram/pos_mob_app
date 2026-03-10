import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Dashboard statistics model
/// Maps to backend AnalyticsSummary: total_revenue, total_orders, tax_collected,
/// gross_sales, net_sales, total_discounts, payment_breakdown
class DashboardStats {
  final double totalSales;
  final double netSales;
  final int totalOrders;
  final double grossSales;
  final double taxCollected;
  final double totalDiscounts;
  final double cashSales;
  final double cardSales;
  final double upiSales;
  final double onlineSales;

  const DashboardStats({
    this.totalSales = 0,
    this.netSales = 0,
    this.totalOrders = 0,
    this.grossSales = 0,
    this.taxCollected = 0,
    this.totalDiscounts = 0,
    this.cashSales = 0,
    this.cardSales = 0,
    this.upiSales = 0,
    this.onlineSales = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    final breakdown = json['payment_breakdown'] as Map<String, dynamic>? ?? {};
    return DashboardStats(
      totalSales: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      netSales: (json['net_sales'] as num?)?.toDouble() ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      grossSales: (json['gross_sales'] as num?)?.toDouble() ?? 0,
      taxCollected: (json['tax_collected'] as num?)?.toDouble() ?? 0,
      totalDiscounts: (json['total_discounts'] as num?)?.toDouble() ?? 0,
      cashSales: (breakdown['cash'] as num?)?.toDouble() ?? 0,
      cardSales: (breakdown['card'] as num?)?.toDouble() ?? 0,
      upiSales: (breakdown['upi'] as num?)?.toDouble() ?? 0,
      onlineSales: (breakdown['wallet'] as num?)?.toDouble() ?? 0,
    );
  }

  static const empty = DashboardStats();

  double get averageOrderValue =>
      totalOrders > 0 ? totalSales / totalOrders : 0;

  /// Backward-compat: completedOrders is just totalOrders from aggregated data
  int get completedOrders => totalOrders;
}

/// Outlet-level statistics (simplified — backend doesn't have per-outlet breakdown)
class OutletStats {
  final String storeId;
  final String storeName;
  final int totalOrders;
  final double totalSales;
  final double netSales;

  const OutletStats({
    required this.storeId,
    required this.storeName,
    this.totalOrders = 0,
    this.totalSales = 0,
    this.netSales = 0,
  });
}

/// Repository for dashboard data
abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats({
    String? storeId,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, List<OutletStats>>> getOutletStats({DateTime? date});
}

/// REST API implementation of DashboardRepository
class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _client;

  DashboardRepositoryImpl(this._client);

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats({
    String? storeId,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // If only date is given, use it as both start and end
      final effectiveStart = startDate ?? date ?? DateTime.now();
      final effectiveEnd = endDate ?? date ?? DateTime.now();
      final startStr = effectiveStart.toIso8601String().split('T')[0];
      final endStr = effectiveEnd.toIso8601String().split('T')[0];

      final queryParams = <String, dynamic>{
        'start_date': startStr,
        'end_date': endStr,
      };
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['store_id'] = storeId;
      }

      final data = await _client.get(
        '/analytics/summary',
        queryParameters: queryParams,
      );

      if (data == null) {
        return right(DashboardStats.empty);
      }

      return right(DashboardStats.fromJson(data as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch dashboard stats: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OutletStats>>> getOutletStats({
    DateTime? date,
  }) async {
    // Backend doesn't provide per-outlet breakdown — return empty
    return right([]);
  }
}
