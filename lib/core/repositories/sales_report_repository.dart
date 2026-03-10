import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Sales report data model.
/// Maps to backend AnalyticsSummary (one entry per store queried).
class SalesReportData {
  final String storeName;
  final String storeId;
  final int totalBills;
  final double totalDiscount;
  final double netSales;
  final double totalTax;
  final double totalSales;
  final double cash;
  final double card;
  final double online;

  const SalesReportData({
    required this.storeName,
    required this.storeId,
    this.totalBills = 0,
    this.totalDiscount = 0,
    this.netSales = 0,
    this.totalTax = 0,
    this.totalSales = 0,
    this.cash = 0,
    this.card = 0,
    this.online = 0,
  });

  factory SalesReportData.fromAnalyticsSummary(
    Map<String, dynamic> json, {
    required String storeId,
    required String storeName,
  }) {
    final breakdown = json['payment_breakdown'] as Map<String, dynamic>? ?? {};
    return SalesReportData(
      storeName: storeName,
      storeId: storeId,
      totalBills: json['total_orders'] as int? ?? 0,
      totalDiscount: (json['total_discounts'] as num?)?.toDouble() ?? 0,
      netSales: (json['net_sales'] as num?)?.toDouble() ?? 0,
      totalTax: (json['tax_collected'] as num?)?.toDouble() ?? 0,
      totalSales: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      cash: (breakdown['cash'] as num?)?.toDouble() ?? 0,
      card: (breakdown['card'] as num?)?.toDouble() ?? 0,
      online:
          ((breakdown['upi'] as num?)?.toDouble() ?? 0) +
          ((breakdown['wallet'] as num?)?.toDouble() ?? 0),
    );
  }
}

/// Sales report summary (aggregates multiple SalesReportData entries)
class SalesReportSummaryData {
  final int total;
  final double totalDiscount;
  final double netSales;
  final double totalTax;
  final double totalSales;
  final double cash;
  final double card;
  final double online;

  const SalesReportSummaryData({
    this.total = 0,
    this.totalDiscount = 0,
    this.netSales = 0,
    this.totalTax = 0,
    this.totalSales = 0,
    this.cash = 0,
    this.card = 0,
    this.online = 0,
  });

  factory SalesReportSummaryData.fromReportData(List<SalesReportData> data) {
    if (data.isEmpty) return const SalesReportSummaryData();
    return SalesReportSummaryData(
      total: data.fold(0, (sum, d) => sum + d.totalBills),
      totalDiscount: data.fold(0.0, (sum, d) => sum + d.totalDiscount),
      netSales: data.fold(0.0, (sum, d) => sum + d.netSales),
      totalTax: data.fold(0.0, (sum, d) => sum + d.totalTax),
      totalSales: data.fold(0.0, (sum, d) => sum + d.totalSales),
      cash: data.fold(0.0, (sum, d) => sum + d.cash),
      card: data.fold(0.0, (sum, d) => sum + d.card),
      online: data.fold(0.0, (sum, d) => sum + d.online),
    );
  }
}

/// Repository for sales reports
abstract class SalesReportRepository {
  Future<Either<Failure, List<SalesReportData>>> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
    required String storeId,
    required String storeName,
  });
}

/// REST API implementation using GET /analytics/summary
class SalesReportRepositoryImpl implements SalesReportRepository {
  final ApiClient _client;

  SalesReportRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<SalesReportData>>> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
    required String storeId,
    required String storeName,
  }) async {
    try {
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final data = await _client.get(
        '/analytics/summary',
        queryParameters: {
          'store_id': storeId,
          'start_date': startStr,
          'end_date': endStr,
        },
      );

      if (data == null) {
        return right([]);
      }

      final report = SalesReportData.fromAnalyticsSummary(
        data as Map<String, dynamic>,
        storeId: storeId,
        storeName: storeName,
      );
      return right([report]);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch sales report: $e'));
    }
  }
}
