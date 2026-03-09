import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Aggregator config model — maps to backend AggregatorConfigResponse
class AggregatorConfigModel {
  final String id;
  final String code;
  final String name;
  final String? webhookSecretHeader;
  final bool isActive;
  final DateTime createdAt;

  const AggregatorConfigModel({
    required this.id,
    required this.code,
    required this.name,
    this.webhookSecretHeader,
    this.isActive = true,
    required this.createdAt,
  });

  factory AggregatorConfigModel.fromJson(Map<String, dynamic> json) {
    return AggregatorConfigModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      webhookSecretHeader: json['webhook_secret_header'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// Aggregator store link model — maps to backend AggregatorStoreLinkResponse
class AggregatorStoreLinkModel {
  final String id;
  final String storeId;
  final String aggregatorId;
  final String externalStoreId;
  final String? apiKey;
  final String? apiSecret;
  final Map<String, dynamic>? config;
  final bool isEnabled;
  final DateTime createdAt;

  const AggregatorStoreLinkModel({
    required this.id,
    required this.storeId,
    required this.aggregatorId,
    required this.externalStoreId,
    this.apiKey,
    this.apiSecret,
    this.config,
    this.isEnabled = true,
    required this.createdAt,
  });

  factory AggregatorStoreLinkModel.fromJson(Map<String, dynamic> json) {
    return AggregatorStoreLinkModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      aggregatorId: json['aggregator_id'] as String,
      externalStoreId: json['external_store_id'] as String,
      apiKey: json['api_key'] as String?,
      apiSecret: json['api_secret'] as String?,
      config: json['config'] as Map<String, dynamic>?,
      isEnabled: json['is_enabled'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// Integration log model — maps to backend IntegrationLogResponse
class IntegrationLogModel {
  final String id;
  final String storeId;
  final String? aggregatorId;
  final String logType;
  final String action;
  final String status;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? details;
  final String? errorMessage;
  final DateTime createdAt;

  const IntegrationLogModel({
    required this.id,
    required this.storeId,
    this.aggregatorId,
    required this.logType,
    required this.action,
    required this.status,
    this.entityType,
    this.entityId,
    this.details,
    this.errorMessage,
    required this.createdAt,
  });

  factory IntegrationLogModel.fromJson(Map<String, dynamic> json) {
    return IntegrationLogModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      aggregatorId: json['aggregator_id'] as String?,
      logType: json['log_type'] as String,
      action: json['action'] as String,
      status: json['status'] as String,
      entityType: json['entity_type'] as String?,
      entityId: json['entity_id'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      errorMessage: json['error_message'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// Aggregator store status — maps to backend AggregatorStoreStatus
class AggregatorStoreStatusModel {
  final String aggregatorId;
  final String aggregatorCode;
  final String aggregatorName;
  final String storeId;
  final String externalStoreId;
  final bool isOnline;
  final bool isEnabled;

  const AggregatorStoreStatusModel({
    required this.aggregatorId,
    required this.aggregatorCode,
    required this.aggregatorName,
    required this.storeId,
    required this.externalStoreId,
    required this.isOnline,
    required this.isEnabled,
  });

  factory AggregatorStoreStatusModel.fromJson(Map<String, dynamic> json) {
    return AggregatorStoreStatusModel(
      aggregatorId: json['aggregator_id'] as String,
      aggregatorCode: json['aggregator_code'] as String,
      aggregatorName: json['aggregator_name'] as String,
      storeId: json['store_id'] as String,
      externalStoreId: json['external_store_id'] as String,
      isOnline: json['is_online'] as bool? ?? false,
      isEnabled: json['is_enabled'] as bool? ?? false,
    );
  }
}

abstract class IntegrationRepository {
  Future<Either<Failure, List<AggregatorConfigModel>>> getAggregators();
  Future<Either<Failure, AggregatorConfigModel>> createAggregator(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, AggregatorConfigModel>> updateAggregator(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<AggregatorStoreLinkModel>>> getStoreLinks(
    String storeId,
  );
  Future<Either<Failure, AggregatorStoreLinkModel>> createStoreLink(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, AggregatorStoreLinkModel>> updateStoreLink(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<IntegrationLogModel>>> getMenuTriggerLogs(
    String storeId, {
    String? aggregatorId,
    int limit,
    int offset,
  });
  Future<Either<Failure, List<IntegrationLogModel>>> getItemLogs(
    String storeId, {
    String? aggregatorId,
    int limit,
    int offset,
  });
  Future<Either<Failure, List<IntegrationLogModel>>> getStoreLogs(
    String storeId, {
    String? aggregatorId,
    int limit,
    int offset,
  });
  Future<Either<Failure, List<AggregatorStoreStatusModel>>> getStoreStatus(
    String storeId,
  );
}

class IntegrationRepositoryImpl implements IntegrationRepository {
  final ApiClient _client;

  IntegrationRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<AggregatorConfigModel>>> getAggregators() async {
    try {
      final response = await _client.get('/integrations/aggregators');
      final aggregators = (response as List)
          .map((e) => AggregatorConfigModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(aggregators);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch aggregators: $e'));
    }
  }

  @override
  Future<Either<Failure, AggregatorConfigModel>> createAggregator(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        '/integrations/aggregators',
        data: data,
      );
      return right(
        AggregatorConfigModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create aggregator: $e'));
    }
  }

  @override
  Future<Either<Failure, AggregatorConfigModel>> updateAggregator(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/integrations/aggregators/$id',
        data: data,
      );
      return right(
        AggregatorConfigModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update aggregator: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AggregatorStoreLinkModel>>> getStoreLinks(
    String storeId,
  ) async {
    try {
      final response = await _client.get(
        '/integrations/store-links',
        queryParameters: {'store_id': storeId},
      );
      final links = (response as List)
          .map(
            (e) => AggregatorStoreLinkModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return right(links);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch store links: $e'));
    }
  }

  @override
  Future<Either<Failure, AggregatorStoreLinkModel>> createStoreLink(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        '/integrations/store-links',
        data: data,
      );
      return right(
        AggregatorStoreLinkModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create store link: $e'));
    }
  }

  @override
  Future<Either<Failure, AggregatorStoreLinkModel>> updateStoreLink(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/integrations/store-links/$id',
        data: data,
      );
      return right(
        AggregatorStoreLinkModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update store link: $e'));
    }
  }

  @override
  Future<Either<Failure, List<IntegrationLogModel>>> getMenuTriggerLogs(
    String storeId, {
    String? aggregatorId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      if (aggregatorId != null) queryParams['aggregator_id'] = aggregatorId;
      final response = await _client.get(
        '/integrations/logs/menu-triggers',
        queryParameters: queryParams,
      );
      final logs = (response as List)
          .map((e) => IntegrationLogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(logs);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch menu trigger logs: $e'));
    }
  }

  @override
  Future<Either<Failure, List<IntegrationLogModel>>> getItemLogs(
    String storeId, {
    String? aggregatorId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      if (aggregatorId != null) queryParams['aggregator_id'] = aggregatorId;
      final response = await _client.get(
        '/integrations/logs/items',
        queryParameters: queryParams,
      );
      final logs = (response as List)
          .map((e) => IntegrationLogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(logs);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch item logs: $e'));
    }
  }

  @override
  Future<Either<Failure, List<IntegrationLogModel>>> getStoreLogs(
    String storeId, {
    String? aggregatorId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      if (aggregatorId != null) queryParams['aggregator_id'] = aggregatorId;
      final response = await _client.get(
        '/integrations/logs/stores',
        queryParameters: queryParams,
      );
      final logs = (response as List)
          .map((e) => IntegrationLogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(logs);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch store logs: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AggregatorStoreStatusModel>>> getStoreStatus(
    String storeId,
  ) async {
    try {
      final response = await _client.get(
        '/integrations/store-status',
        queryParameters: {'store_id': storeId},
      );
      final statuses = (response as List)
          .map(
            (e) =>
                AggregatorStoreStatusModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return right(statuses);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch store status: $e'));
    }
  }
}
