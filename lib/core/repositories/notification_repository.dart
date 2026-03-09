import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Notification model — maps to backend NotificationResponse
class NotificationModel {
  final String id;
  final String userId;
  final String? storeId;
  final String title;
  final String? body;
  final String category;
  final String? entityType;
  final String? entityId;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    this.storeId,
    required this.title,
    this.body,
    this.category = 'general',
    this.entityType,
    this.entityId,
    this.isRead = false,
    this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      storeId: json['store_id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String?,
      category: json['category'] as String? ?? 'general',
      entityType: json['entity_type'] as String?,
      entityId: json['entity_id'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    String? storeId,
    String? category,
    bool? isRead,
    int limit,
    int offset,
  });
  Future<Either<Failure, NotificationModel>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead({String? storeId});
}

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiClient _client;

  NotificationRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    String? storeId,
    String? category,
    bool? isRead,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit, 'offset': offset};
      if (storeId != null) queryParams['store_id'] = storeId;
      if (category != null) queryParams['category'] = category;
      if (isRead != null) queryParams['is_read'] = isRead;
      final response = await _client.get(
        '/notifications',
        queryParameters: queryParams,
      );
      final notifications = (response as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(notifications);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch notifications: $e'));
    }
  }

  @override
  Future<Either<Failure, NotificationModel>> markAsRead(String id) async {
    try {
      final response = await _client.put(
        '/notifications/$id/read',
        data: {'is_read': true},
      );
      return right(
        NotificationModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to mark notification as read: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead({String? storeId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (storeId != null) queryParams['store_id'] = storeId;
      await _client.post(
        '/notifications/mark-all-read',
        data: queryParams.isNotEmpty ? queryParams : null,
      );
      return right(null);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to mark all as read: $e'));
    }
  }
}
