import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Model ──────────────────────────────────────────────

class DeliveryModel {
  final String id;
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String? landmark;
  final double? latitude;
  final double? longitude;
  final String deliveryType;
  final String deliveryStatus;
  final String? deliveryEmployeeId;
  final double deliveryCharge;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? proofImageUrl;
  final String? signatureUrl;
  final String? deliveryNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeliveryModel({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    this.landmark,
    this.latitude,
    this.longitude,
    required this.deliveryType,
    required this.deliveryStatus,
    this.deliveryEmployeeId,
    required this.deliveryCharge,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.proofImageUrl,
    this.signatureUrl,
    this.deliveryNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      customerName: json['customer_name'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      deliveryAddress: json['delivery_address'] as String? ?? '',
      landmark: json['landmark'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      deliveryType: json['delivery_type'] as String? ?? 'own_delivery',
      deliveryStatus: json['delivery_status'] as String? ?? 'pending',
      deliveryEmployeeId: json['delivery_employee_id'] as String?,
      deliveryCharge: (json['delivery_charge'] as num?)?.toDouble() ?? 0,
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'] as String)
          : null,
      actualDeliveryTime: json['actual_delivery_time'] != null
          ? DateTime.parse(json['actual_delivery_time'] as String)
          : null,
      proofImageUrl: json['proof_image_url'] as String?,
      signatureUrl: json['signature_url'] as String?,
      deliveryNotes: json['delivery_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class DeliveryRepository {
  Future<Either<Failure, DeliveryModel>> createDelivery(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, DeliveryModel>> getDelivery(String orderId);
  Future<Either<Failure, DeliveryModel>> updateDelivery(
    String orderId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, DeliveryModel>> updateDeliveryStatus(
    String orderId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<DeliveryModel>>> listDeliveries({
    required String storeId,
    String? status,
  });
}

// ── Implementation ─────────────────────────────────────

class DeliveryRepositoryImpl implements DeliveryRepository {
  final ApiClient _client;
  DeliveryRepositoryImpl(this._client);

  @override
  Future<Either<Failure, DeliveryModel>> createDelivery(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/deliveries', data: data);
      return right(DeliveryModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, DeliveryModel>> getDelivery(String orderId) async {
    try {
      final response = await _client.get('/deliveries/$orderId');
      return right(DeliveryModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, DeliveryModel>> updateDelivery(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/deliveries/$orderId', data: data);
      return right(DeliveryModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, DeliveryModel>> updateDeliveryStatus(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/deliveries/$orderId/status',
        data: data,
      );
      return right(DeliveryModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DeliveryModel>>> listDeliveries({
    required String storeId,
    String? status,
  }) async {
    try {
      final params = <String, dynamic>{'store_id': storeId};
      if (status != null) params['delivery_status'] = status;
      final data = await _client.get('/deliveries', queryParameters: params);
      final list = (data as List)
          .map((e) => DeliveryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
