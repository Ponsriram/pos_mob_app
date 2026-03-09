import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Models ─────────────────────────────────────────────

class ShiftPaymentSummaryModel {
  final String id;
  final String shiftId;
  final String paymentMethod;
  final double expectedAmount;
  final double? actualAmount;
  final double? variance;

  const ShiftPaymentSummaryModel({
    required this.id,
    required this.shiftId,
    required this.paymentMethod,
    required this.expectedAmount,
    this.actualAmount,
    this.variance,
  });

  factory ShiftPaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return ShiftPaymentSummaryModel(
      id: json['id'] as String,
      shiftId: json['shift_id'] as String,
      paymentMethod: json['payment_method'] as String,
      expectedAmount: (json['expected_amount'] as num?)?.toDouble() ?? 0,
      actualAmount: (json['actual_amount'] as num?)?.toDouble(),
      variance: (json['variance'] as num?)?.toDouble(),
    );
  }
}

class ShiftModel {
  final String id;
  final String storeId;
  final String? terminalId;
  final String employeeId;
  final String status;
  final double openingCash;
  final double? closingCash;
  final double? expectedCash;
  final double? cashVariance;
  final double totalSales;
  final int totalOrders;
  final String? notes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<ShiftPaymentSummaryModel> paymentSummaries;

  const ShiftModel({
    required this.id,
    required this.storeId,
    this.terminalId,
    required this.employeeId,
    required this.status,
    required this.openingCash,
    this.closingCash,
    this.expectedCash,
    this.cashVariance,
    required this.totalSales,
    required this.totalOrders,
    this.notes,
    required this.startedAt,
    this.endedAt,
    this.paymentSummaries = const [],
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String?,
      employeeId: json['employee_id'] as String,
      status: json['status'] as String? ?? 'open',
      openingCash: (json['opening_cash'] as num?)?.toDouble() ?? 0,
      closingCash: (json['closing_cash'] as num?)?.toDouble(),
      expectedCash: (json['expected_cash'] as num?)?.toDouble(),
      cashVariance: (json['cash_variance'] as num?)?.toDouble(),
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      notes: json['notes'] as String?,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : DateTime.now(),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      paymentSummaries:
          (json['payment_summaries'] as List?)
              ?.map(
                (e) => ShiftPaymentSummaryModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class DayCloseModel {
  final String id;
  final String storeId;
  final String businessDate;
  final int totalOrders;
  final double grossSales;
  final double totalTax;
  final double totalDiscounts;
  final double totalServiceCharge;
  final double totalTips;
  final double netSales;
  final double totalExpenses;
  final double netCash;
  final Map<String, dynamic>? paymentBreakdown;
  final Map<String, dynamic>? orderTypeBreakdown;
  final int cancelledOrders;
  final String? closedBy;
  final DateTime closedAt;

  const DayCloseModel({
    required this.id,
    required this.storeId,
    required this.businessDate,
    required this.totalOrders,
    required this.grossSales,
    required this.totalTax,
    required this.totalDiscounts,
    required this.totalServiceCharge,
    required this.totalTips,
    required this.netSales,
    required this.totalExpenses,
    required this.netCash,
    this.paymentBreakdown,
    this.orderTypeBreakdown,
    required this.cancelledOrders,
    this.closedBy,
    required this.closedAt,
  });

  factory DayCloseModel.fromJson(Map<String, dynamic> json) {
    return DayCloseModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      businessDate: json['business_date'] as String,
      totalOrders: json['total_orders'] as int? ?? 0,
      grossSales: (json['gross_sales'] as num?)?.toDouble() ?? 0,
      totalTax: (json['total_tax'] as num?)?.toDouble() ?? 0,
      totalDiscounts: (json['total_discounts'] as num?)?.toDouble() ?? 0,
      totalServiceCharge:
          (json['total_service_charge'] as num?)?.toDouble() ?? 0,
      totalTips: (json['total_tips'] as num?)?.toDouble() ?? 0,
      netSales: (json['net_sales'] as num?)?.toDouble() ?? 0,
      totalExpenses: (json['total_expenses'] as num?)?.toDouble() ?? 0,
      netCash: (json['net_cash'] as num?)?.toDouble() ?? 0,
      paymentBreakdown: json['payment_breakdown'] as Map<String, dynamic>?,
      orderTypeBreakdown: json['order_type_breakdown'] as Map<String, dynamic>?,
      cancelledOrders: json['cancelled_orders'] as int? ?? 0,
      closedBy: json['closed_by'] as String?,
      closedAt: json['closed_at'] != null
          ? DateTime.parse(json['closed_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class ShiftRepository {
  Future<Either<Failure, ShiftModel>> openShift(Map<String, dynamic> data);
  Future<Either<Failure, ShiftModel>> getShift(String shiftId);
  Future<Either<Failure, List<ShiftModel>>> listShifts({
    required String storeId,
    String? status,
    int limit = 50,
    int offset = 0,
  });
  Future<Either<Failure, ShiftModel>> closeShift(
    String shiftId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, DayCloseModel>> generateDayClose(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<DayCloseModel>>> listDayCloses({
    required String storeId,
    String? startDate,
    String? endDate,
  });
}

// ── Implementation ─────────────────────────────────────

class ShiftRepositoryImpl implements ShiftRepository {
  final ApiClient _client;
  ShiftRepositoryImpl(this._client);

  @override
  Future<Either<Failure, ShiftModel>> openShift(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/shifts', data: data);
      return right(ShiftModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, ShiftModel>> getShift(String shiftId) async {
    try {
      final response = await _client.get('/shifts/$shiftId');
      return right(ShiftModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ShiftModel>>> listShifts({
    required String storeId,
    String? status,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      if (status != null) params['status'] = status;
      final data = await _client.get('/shifts', queryParameters: params);
      final list = (data as List)
          .map((e) => ShiftModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, ShiftModel>> closeShift(
    String shiftId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/shifts/$shiftId/close', data: data);
      return right(ShiftModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, DayCloseModel>> generateDayClose(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/shifts/day-close', data: data);
      return right(DayCloseModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DayCloseModel>>> listDayCloses({
    required String storeId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final params = <String, dynamic>{'store_id': storeId};
      if (startDate != null) params['start_date'] = startDate;
      if (endDate != null) params['end_date'] = endDate;
      final data = await _client.get(
        '/shifts/day-close',
        queryParameters: params,
      );
      final list = (data as List)
          .map((e) => DayCloseModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
