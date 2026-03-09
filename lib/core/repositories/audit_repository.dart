import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Model ──────────────────────────────────────────────

class AuditLogModel {
  final String id;
  final String storeId;
  final String? userId;
  final String? employeeId;
  final String action;
  final String entityType;
  final String? entityId;
  final String? description;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final String? ipAddress;
  final DateTime createdAt;

  const AuditLogModel({
    required this.id,
    required this.storeId,
    this.userId,
    this.employeeId,
    required this.action,
    required this.entityType,
    this.entityId,
    this.description,
    this.oldValues,
    this.newValues,
    this.ipAddress,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String?,
      employeeId: json['employee_id'] as String?,
      action: json['action'] as String? ?? '',
      entityType: json['entity_type'] as String? ?? '',
      entityId: json['entity_id'] as String?,
      description: json['description'] as String?,
      oldValues: json['old_values'] as Map<String, dynamic>?,
      newValues: json['new_values'] as Map<String, dynamic>?,
      ipAddress: json['ip_address'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class AuditRepository {
  Future<Either<Failure, List<AuditLogModel>>> listAuditLogs({
    required String storeId,
    String? entityType,
    String? action,
    String? userId,
    int limit = 50,
    int offset = 0,
  });
}

// ── Implementation ─────────────────────────────────────

class AuditRepositoryImpl implements AuditRepository {
  final ApiClient _client;
  AuditRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<AuditLogModel>>> listAuditLogs({
    required String storeId,
    String? entityType,
    String? action,
    String? userId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      if (entityType != null) params['entity_type'] = entityType;
      if (action != null) params['action'] = action;
      if (userId != null) params['user_id'] = userId;
      final data = await _client.get('/audit/logs', queryParameters: params);
      final list = (data as List)
          .map((e) => AuditLogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
