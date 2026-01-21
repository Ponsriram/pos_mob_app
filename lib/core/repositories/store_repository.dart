import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/core/error/failure.dart';

/// Store model representing a business outlet
class StoreModel {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final String? logoUrl;
  final String? gstNumber;
  final String storeType;
  final bool isActive;
  final DateTime createdAt;

  const StoreModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.logoUrl,
    this.gstNumber,
    this.storeType = 'restaurant',
    this.isActive = true,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      logoUrl: json['logo_url'] as String?,
      gstNumber: json['gst_number'] as String?,
      storeType: json['store_type'] as String? ?? 'restaurant',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'logo_url': logoUrl,
      'gst_number': gstNumber,
      'store_type': storeType,
      'is_active': isActive,
    };
  }
}

/// Repository for store/outlet operations
abstract class StoreRepository {
  Future<Either<Failure, List<StoreModel>>> getStores();
  Future<Either<Failure, StoreModel>> getStoreById(String id);
  Future<Either<Failure, List<StoreModel>>> getAccessibleStores();
  Stream<List<StoreModel>> watchStores();
}

/// Supabase implementation of StoreRepository
class StoreRepositoryImpl implements StoreRepository {
  final SupabaseClient _client;

  StoreRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<StoreModel>>> getStores() async {
    try {
      final response = await _client
          .from('stores')
          .select()
          .eq('is_active', true)
          .order('name');

      final stores = (response as List)
          .map((e) => StoreModel.fromJson(e))
          .toList();
      return right(stores);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch stores: $e'));
    }
  }

  @override
  Future<Either<Failure, StoreModel>> getStoreById(String id) async {
    try {
      final response = await _client
          .from('stores')
          .select()
          .eq('id', id)
          .single();

      return right(StoreModel.fromJson(response));
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch store: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StoreModel>>> getAccessibleStores() async {
    try {
      // Get current user's profile with accessible stores
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return left(const AuthFailure(message: 'User not authenticated'));
      }

      final profileResponse = await _client
          .from('profiles')
          .select('store_id, accessible_store_ids')
          .eq('id', userId)
          .single();

      final storeId = profileResponse['store_id'] as String?;
      final accessibleIds =
          (profileResponse['accessible_store_ids'] as List?)?.cast<String>() ??
          [];

      // Combine primary store with accessible stores
      final allStoreIds = <String>{
        if (storeId != null) storeId,
        ...accessibleIds,
      }.toList();

      if (allStoreIds.isEmpty) {
        return right([]);
      }

      final storesResponse = await _client
          .from('stores')
          .select()
          .inFilter('id', allStoreIds)
          .eq('is_active', true)
          .order('name');

      final stores = (storesResponse as List)
          .map((e) => StoreModel.fromJson(e))
          .toList();
      return right(stores);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch accessible stores: $e'));
    }
  }

  @override
  Stream<List<StoreModel>> watchStores() {
    return _client
        .from('stores')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('name')
        .map((data) => data.map((e) => StoreModel.fromJson(e)).toList());
  }
}
