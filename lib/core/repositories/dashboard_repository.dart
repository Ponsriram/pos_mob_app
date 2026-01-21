import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/core/error/failure.dart';

/// Dashboard statistics model
class DashboardStats {
  final double totalSales;
  final double netSales;
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int cancelledOrders;
  final double averageOrderValue;
  final int totalCustomers;
  final double cashSales;
  final double cardSales;
  final double upiSales;
  final double onlineSales;

  const DashboardStats({
    this.totalSales = 0,
    this.netSales = 0,
    this.totalOrders = 0,
    this.completedOrders = 0,
    this.pendingOrders = 0,
    this.cancelledOrders = 0,
    this.averageOrderValue = 0,
    this.totalCustomers = 0,
    this.cashSales = 0,
    this.cardSales = 0,
    this.upiSales = 0,
    this.onlineSales = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0,
      netSales: (json['net_sales'] as num?)?.toDouble() ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      completedOrders: json['completed_orders'] as int? ?? 0,
      pendingOrders: json['pending_orders'] as int? ?? 0,
      cancelledOrders: json['cancelled_orders'] as int? ?? 0,
      averageOrderValue: (json['average_order_value'] as num?)?.toDouble() ?? 0,
      totalCustomers: json['total_customers'] as int? ?? 0,
      cashSales: (json['cash_sales'] as num?)?.toDouble() ?? 0,
      cardSales: (json['card_sales'] as num?)?.toDouble() ?? 0,
      upiSales: (json['upi_sales'] as num?)?.toDouble() ?? 0,
      onlineSales: (json['online_sales'] as num?)?.toDouble() ?? 0,
    );
  }

  static const empty = DashboardStats();
}

/// Outlet-specific statistics
class OutletStats {
  final String storeId;
  final String storeName;
  final double totalSales;
  final int totalOrders;
  final int itemsSold;
  final double netSales;

  const OutletStats({
    required this.storeId,
    required this.storeName,
    this.totalSales = 0,
    this.totalOrders = 0,
    this.itemsSold = 0,
    this.netSales = 0,
  });

  factory OutletStats.fromJson(Map<String, dynamic> json) {
    return OutletStats(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String? ?? 'Unknown',
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      itemsSold: json['items_sold'] as int? ?? 0,
      netSales: (json['net_sales'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Repository for dashboard data
abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats({
    required String? storeId,
    required DateTime date,
  });

  Future<Either<Failure, List<OutletStats>>> getOutletStats({
    required DateTime date,
  });

  Future<Either<Failure, Map<String, dynamic>>> getDailySalesSummary({
    required String storeId,
    required DateTime date,
  });
}

/// Supabase implementation of DashboardRepository
class DashboardRepositoryImpl implements DashboardRepository {
  final SupabaseClient _client;

  DashboardRepositoryImpl(this._client);

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats({
    required String? storeId,
    required DateTime date,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];

      if (storeId != null && storeId != 'all') {
        // Call Supabase RPC function for specific store
        final response = await _client.rpc(
          'get_dashboard_stats',
          params: {'p_store_id': storeId, 'p_date': dateStr},
        );

        if (response == null) {
          return right(DashboardStats.empty);
        }

        return right(DashboardStats.fromJson(response as Map<String, dynamic>));
      } else {
        // Aggregate stats for all stores
        final response = await _client.rpc(
          'get_dashboard_stats_all',
          params: {'p_date': dateStr},
        );

        if (response == null) {
          return right(DashboardStats.empty);
        }

        return right(DashboardStats.fromJson(response as Map<String, dynamic>));
      }
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch dashboard stats: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OutletStats>>> getOutletStats({
    required DateTime date,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];

      final response = await _client.rpc(
        'get_outlet_stats',
        params: {'p_date': dateStr},
      );

      if (response == null) {
        return right([]);
      }

      final stats = (response as List)
          .map((e) => OutletStats.fromJson(e))
          .toList();
      return right(stats);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch outlet stats: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDailySalesSummary({
    required String storeId,
    required DateTime date,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];

      final response = await _client.rpc(
        'get_daily_sales_summary',
        params: {'p_store_id': storeId, 'p_date': dateStr},
      );

      if (response == null) {
        return right({});
      }

      return right(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch sales summary: $e'));
    }
  }
}
