import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Model ──────────────────────────────────────────────

class CampaignModel {
  final String id;
  final String storeId;
  final String name;
  final String subject;
  final String content;
  final String targetSegment;
  final Map<String, dynamic>? segmentFilters;
  final String status;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final int totalRecipients;
  final int totalSent;
  final int totalOpened;
  final int totalClicked;
  final DateTime createdAt;

  const CampaignModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.subject,
    required this.content,
    required this.targetSegment,
    this.segmentFilters,
    required this.status,
    this.scheduledAt,
    this.sentAt,
    required this.totalRecipients,
    required this.totalSent,
    required this.totalOpened,
    required this.totalClicked,
    required this.createdAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      content: json['content'] as String? ?? '',
      targetSegment: json['target_segment'] as String? ?? 'all',
      segmentFilters: json['segment_filters'] as Map<String, dynamic>?,
      status: json['status'] as String? ?? 'draft',
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'] as String)
          : null,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      totalRecipients: json['total_recipients'] as int? ?? 0,
      totalSent: json['total_sent'] as int? ?? 0,
      totalOpened: json['total_opened'] as int? ?? 0,
      totalClicked: json['total_clicked'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class MarketingRepository {
  Future<Either<Failure, CampaignModel>> createCampaign(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<CampaignModel>>> listCampaigns({
    required String storeId,
    String? status,
    int limit = 50,
    int offset = 0,
  });
  Future<Either<Failure, CampaignModel>> getCampaign(String campaignId);
  Future<Either<Failure, CampaignModel>> updateCampaign(
    String campaignId,
    Map<String, dynamic> data,
  );
}

// ── Implementation ─────────────────────────────────────

class MarketingRepositoryImpl implements MarketingRepository {
  final ApiClient _client;
  MarketingRepositoryImpl(this._client);

  @override
  Future<Either<Failure, CampaignModel>> createCampaign(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/marketing/campaigns', data: data);
      return right(CampaignModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CampaignModel>>> listCampaigns({
    required String storeId,
    String? status,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      if (status != null) params['status'] = status;
      final data = await _client.get(
        '/marketing/campaigns',
        queryParameters: params,
      );
      final list = (data as List)
          .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, CampaignModel>> getCampaign(String campaignId) async {
    try {
      final response = await _client.get('/marketing/campaigns/$campaignId');
      return right(CampaignModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, CampaignModel>> updateCampaign(
    String campaignId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/marketing/campaigns/$campaignId',
        data: data,
      );
      return right(CampaignModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
