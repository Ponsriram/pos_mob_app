import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Model ──────────────────────────────────────────────

class GuestModel {
  final String id;
  final String storeId;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? dietaryPreference;
  final String? spiceLevel;
  final String? allergies;
  final String? notes;
  final List<dynamic>? tags;
  final int totalVisits;
  final double totalSpend;
  final DateTime? lastVisitAt;
  final int loyaltyPoints;
  final bool isActive;
  final DateTime createdAt;

  const GuestModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.dietaryPreference,
    this.spiceLevel,
    this.allergies,
    this.notes,
    this.tags,
    required this.totalVisits,
    required this.totalSpend,
    this.lastVisitAt,
    required this.loyaltyPoints,
    required this.isActive,
    required this.createdAt,
  });

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      dietaryPreference: json['dietary_preference'] as String?,
      spiceLevel: json['spice_level'] as String?,
      allergies: json['allergies'] as String?,
      notes: json['notes'] as String?,
      tags: json['tags'] as List?,
      totalVisits: json['total_visits'] as int? ?? 0,
      totalSpend: (json['total_spend'] as num?)?.toDouble() ?? 0,
      lastVisitAt: json['last_visit_at'] != null
          ? DateTime.parse(json['last_visit_at'] as String)
          : null,
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class GuestRepository {
  Future<Either<Failure, GuestModel>> createGuest(Map<String, dynamic> data);
  Future<Either<Failure, List<GuestModel>>> listGuests({
    required String storeId,
    String? search,
    bool activeOnly = true,
    int limit = 50,
    int offset = 0,
  });
  Future<Either<Failure, GuestModel>> getGuest(String guestId);
  Future<Either<Failure, GuestModel>> updateGuest(
    String guestId,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, GuestModel>> adjustLoyalty(
    String guestId,
    Map<String, dynamic> data,
  );
}

// ── Implementation ─────────────────────────────────────

class GuestRepositoryImpl implements GuestRepository {
  final ApiClient _client;
  GuestRepositoryImpl(this._client);

  @override
  Future<Either<Failure, GuestModel>> createGuest(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/guests', data: data);
      return right(GuestModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<GuestModel>>> listGuests({
    required String storeId,
    String? search,
    bool activeOnly = true,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'store_id': storeId,
        'active_only': activeOnly,
        'limit': limit,
        'offset': offset,
      };
      if (search != null) params['search'] = search;
      final data = await _client.get('/guests', queryParameters: params);
      final list = (data as List)
          .map((e) => GuestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, GuestModel>> getGuest(String guestId) async {
    try {
      final response = await _client.get('/guests/$guestId');
      return right(GuestModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, GuestModel>> updateGuest(
    String guestId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/guests/$guestId', data: data);
      return right(GuestModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, GuestModel>> adjustLoyalty(
    String guestId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        '/guests/$guestId/loyalty',
        data: data,
      );
      return right(GuestModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
