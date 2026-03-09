import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Permission group model — maps to backend PermissionGroupResponse
class PermissionGroupModel {
  final String id;
  final String ownerId;
  final String name;
  final String groupType; // 'admin' or 'biller'
  final List<String> permissions;
  final bool isActive;
  final List<String> storeIds;
  final List<String> memberUserIds;
  final DateTime createdAt;

  const PermissionGroupModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.groupType,
    this.permissions = const [],
    this.isActive = true,
    this.storeIds = const [],
    this.memberUserIds = const [],
    required this.createdAt,
  });

  factory PermissionGroupModel.fromJson(Map<String, dynamic> json) {
    return PermissionGroupModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      groupType: json['group_type'] as String? ?? 'admin',
      permissions:
          (json['permissions'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      isActive: json['is_active'] as bool? ?? true,
      storeIds:
          (json['store_ids'] as List?)?.map((e) => e.toString()).toList() ?? [],
      memberUserIds:
          (json['member_user_ids'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// Repository for permission group operations
abstract class GroupRepository {
  Future<Either<Failure, List<PermissionGroupModel>>> getGroups({
    String? groupType,
  });
  Future<Either<Failure, PermissionGroupModel>> getGroupById(String id);
  Future<Either<Failure, PermissionGroupModel>> createGroup(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, PermissionGroupModel>> updateGroup(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deactivateGroup(String id);
}

/// REST API implementation of GroupRepository
class GroupRepositoryImpl implements GroupRepository {
  final ApiClient _client;

  GroupRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<PermissionGroupModel>>> getGroups({
    String? groupType,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (groupType != null) queryParams['group_type'] = groupType;
      final response = await _client.get(
        '/groups',
        queryParameters: queryParams,
      );
      final groups = (response as List)
          .map((e) => PermissionGroupModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(groups);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch groups: $e'));
    }
  }

  @override
  Future<Either<Failure, PermissionGroupModel>> getGroupById(String id) async {
    try {
      final response = await _client.get('/groups/$id');
      return right(
        PermissionGroupModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch group: $e'));
    }
  }

  @override
  Future<Either<Failure, PermissionGroupModel>> createGroup(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/groups', data: data);
      return right(
        PermissionGroupModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create group: $e'));
    }
  }

  @override
  Future<Either<Failure, PermissionGroupModel>> updateGroup(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/groups/$id', data: data);
      return right(
        PermissionGroupModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update group: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateGroup(String id) async {
    try {
      await _client.delete('/groups/$id');
      return right(null);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to deactivate group: $e'));
    }
  }
}
