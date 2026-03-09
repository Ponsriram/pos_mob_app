import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Zone model — maps to backend ZoneResponse
class ZoneModel {
  final String id;
  final String ownerId;
  final String name;
  final String? state;
  final String? city;
  final String subOrderType;
  final double deliveryFee;
  final double minOrderAmount;
  final Map<String, dynamic>? boundary;
  final bool isActive;
  final List<String> storeIds;
  final DateTime createdAt;

  const ZoneModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.state,
    this.city,
    this.subOrderType = 'delivery',
    this.deliveryFee = 0,
    this.minOrderAmount = 0,
    this.boundary,
    this.isActive = true,
    this.storeIds = const [],
    required this.createdAt,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      state: json['state'] as String?,
      city: json['city'] as String?,
      subOrderType: json['sub_order_type'] as String? ?? 'delivery',
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      minOrderAmount: (json['min_order_amount'] as num?)?.toDouble() ?? 0,
      boundary: json['boundary'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool? ?? true,
      storeIds:
          (json['store_ids'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      'sub_order_type': subOrderType,
      'delivery_fee': deliveryFee,
      'min_order_amount': minOrderAmount,
      if (boundary != null) 'boundary': boundary,
      'store_ids': storeIds,
    };
  }
}

/// Repository for zone operations
abstract class ZoneRepository {
  Future<Either<Failure, List<ZoneModel>>> getZones({bool? isActive});
  Future<Either<Failure, ZoneModel>> getZoneById(String id);
  Future<Either<Failure, ZoneModel>> createZone(Map<String, dynamic> data);
  Future<Either<Failure, ZoneModel>> updateZone(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deactivateZone(String id);
}

/// REST API implementation of ZoneRepository
class ZoneRepositoryImpl implements ZoneRepository {
  final ApiClient _client;

  ZoneRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<ZoneModel>>> getZones({bool? isActive}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (isActive != null) queryParams['is_active'] = isActive;
      final response = await _client.get(
        '/zones',
        queryParameters: queryParams,
      );
      final zones = (response as List)
          .map((e) => ZoneModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(zones);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch zones: $e'));
    }
  }

  @override
  Future<Either<Failure, ZoneModel>> getZoneById(String id) async {
    try {
      final response = await _client.get('/zones/$id');
      return right(ZoneModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch zone: $e'));
    }
  }

  @override
  Future<Either<Failure, ZoneModel>> createZone(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/zones', data: data);
      return right(ZoneModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create zone: $e'));
    }
  }

  @override
  Future<Either<Failure, ZoneModel>> updateZone(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/zones/$id', data: data);
      return right(ZoneModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update zone: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateZone(String id) async {
    try {
      await _client.delete('/zones/$id');
      return right(null);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to deactivate zone: $e'));
    }
  }
}
