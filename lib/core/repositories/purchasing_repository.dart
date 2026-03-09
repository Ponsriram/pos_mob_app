import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Vendor model — maps to backend VendorResponse
class VendorModel {
  final String id;
  final String storeId;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? gstNumber;
  final int paymentTermsDays;
  final bool isActive;
  final DateTime createdAt;

  const VendorModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.gstNumber,
    this.paymentTermsDays = 0,
    this.isActive = true,
    required this.createdAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      contactPerson: json['contact_person'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      gstNumber: json['gst_number'] as String?,
      paymentTermsDays: json['payment_terms_days'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// Pending purchase summary — maps to backend PendingPurchaseSummaryItem
class PendingPurchaseSummaryModel {
  final String storeId;
  final String? vendorId;
  final String? vendorName;
  final int pendingOrdersCount;
  final double totalPendingAmount;

  const PendingPurchaseSummaryModel({
    required this.storeId,
    this.vendorId,
    this.vendorName,
    required this.pendingOrdersCount,
    required this.totalPendingAmount,
  });

  factory PendingPurchaseSummaryModel.fromJson(Map<String, dynamic> json) {
    return PendingPurchaseSummaryModel(
      storeId: json['store_id'] as String,
      vendorId: json['vendor_id'] as String?,
      vendorName: json['vendor_name'] as String?,
      pendingOrdersCount: json['pending_orders_count'] as int? ?? 0,
      totalPendingAmount:
          (json['total_pending_amount'] as num?)?.toDouble() ?? 0,
    );
  }
}

abstract class PurchasingRepository {
  Future<Either<Failure, List<VendorModel>>> getVendors(
    String storeId, {
    bool activeOnly = true,
  });
  Future<Either<Failure, VendorModel>> createVendor(Map<String, dynamic> data);
  Future<Either<Failure, VendorModel>> updateVendor(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<PendingPurchaseSummaryModel>>> getPendingSummary(
    String storeId,
  );
}

class PurchasingRepositoryImpl implements PurchasingRepository {
  final ApiClient _client;

  PurchasingRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<VendorModel>>> getVendors(
    String storeId, {
    bool activeOnly = true,
  }) async {
    try {
      final response = await _client.get(
        '/purchasing/vendors',
        queryParameters: {'store_id': storeId, 'active_only': activeOnly},
      );
      final vendors = (response as List)
          .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(vendors);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch vendors: $e'));
    }
  }

  @override
  Future<Either<Failure, VendorModel>> createVendor(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/purchasing/vendors', data: data);
      return right(VendorModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create vendor: $e'));
    }
  }

  @override
  Future<Either<Failure, VendorModel>> updateVendor(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/purchasing/vendors/$id', data: data);
      return right(VendorModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update vendor: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PendingPurchaseSummaryModel>>> getPendingSummary(
    String storeId,
  ) async {
    try {
      final response = await _client.get(
        '/purchasing/pending-summary',
        queryParameters: {'store_id': storeId},
      );
      final items = (response as List)
          .map(
            (e) =>
                PendingPurchaseSummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return right(items);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch pending summary: $e'));
    }
  }
}
