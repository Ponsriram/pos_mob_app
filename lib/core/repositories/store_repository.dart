import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Store model representing a business outlet
class StoreModel {
  final String id;
  final String name;
  final String? location;
  final String? phone;
  final String? email;
  final String timezone;
  final String currency;
  final bool taxInclusive;
  final String? ownerId;
  final String? chainId;
  final bool isActive;
  final DateTime createdAt;

  const StoreModel({
    required this.id,
    required this.name,
    this.location,
    this.phone,
    this.email,
    this.timezone = 'Asia/Kolkata',
    this.currency = 'INR',
    this.taxInclusive = false,
    this.ownerId,
    this.chainId,
    this.isActive = true,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      timezone: json['timezone'] as String? ?? 'Asia/Kolkata',
      currency: json['currency'] as String? ?? 'INR',
      taxInclusive: json['tax_inclusive'] as bool? ?? false,
      ownerId: json['owner_id']?.toString(),
      chainId: json['chain_id']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'phone': phone,
      'email': email,
      'timezone': timezone,
      'currency': currency,
      'tax_inclusive': taxInclusive,
      if (chainId != null) 'chain_id': chainId,
    };
  }

  /// Backward-compatible address getter (maps location → address)
  String? get address => location;
}

/// Repository for store/outlet operations
abstract class StoreRepository {
  Future<Either<Failure, List<StoreModel>>> getStores();
  Future<Either<Failure, List<StoreModel>>> getAccessibleStores();
  Future<Either<Failure, StoreModel>> getStoreById(String id);
  Future<Either<Failure, StoreModel>> createStore(Map<String, dynamic> data);
}

/// REST API implementation of StoreRepository
class StoreRepositoryImpl implements StoreRepository {
  final ApiClient _client;

  StoreRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<StoreModel>>> getStores() async {
    try {
      final response = await _client.get('/stores');
      final stores = (response.data as List)
          .map((e) => StoreModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(stores);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch stores: $e'));
    }
  }

  @override
  Future<Either<Failure, StoreModel>> getStoreById(String id) async {
    try {
      final response = await _client.get('/stores/$id');
      return right(StoreModel.fromJson(response.data as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch store: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StoreModel>>> getAccessibleStores() =>
      getStores();

  @override
  Future<Either<Failure, StoreModel>> createStore(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/stores', data: data);
      return right(StoreModel.fromJson(response.data as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create store: $e'));
    }
  }
}
