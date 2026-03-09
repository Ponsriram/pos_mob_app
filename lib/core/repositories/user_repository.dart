import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Sub-user model — maps to backend UserResponse
class SubUserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  const SubUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory SubUserModel.fromJson(Map<String, dynamic> json) {
    return SubUserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'user',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

abstract class UserRepository {
  Future<Either<Failure, List<SubUserModel>>> getSubUsers({
    String? role,
    bool? isActive,
    int limit,
    int offset,
  });
}

class UserRepositoryImpl implements UserRepository {
  final ApiClient _client;
  UserRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<SubUserModel>>> getSubUsers({
    String? role,
    bool? isActive,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit, 'offset': offset};
      if (role != null) queryParams['role'] = role;
      if (isActive != null) queryParams['is_active'] = isActive;

      final data = await _client.get('/users', queryParameters: queryParams);
      final list = (data as List)
          .map((e) => SubUserModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
