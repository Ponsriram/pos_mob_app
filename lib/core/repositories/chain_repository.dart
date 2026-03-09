import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';
import 'package:pos_app/core/repositories/store_repository.dart';

/// Chain model — maps to backend ChainResponse
class ChainModel {
  final String id;
  final String ownerId;
  final String name;
  final String? logoUrl;
  final DateTime createdAt;

  const ChainModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.logoUrl,
    required this.createdAt,
  });

  factory ChainModel.fromJson(Map<String, dynamic> json) {
    return ChainModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

abstract class ChainRepository {
  Future<Either<Failure, List<ChainModel>>> getChains();
  Future<Either<Failure, ChainModel>> getChainById(String id);
  Future<Either<Failure, ChainModel>> createChain(Map<String, dynamic> data);
  Future<Either<Failure, ChainModel>> updateChain(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<StoreModel>>> getChainStores(String chainId);
}

class ChainRepositoryImpl implements ChainRepository {
  final ApiClient _client;

  ChainRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<ChainModel>>> getChains() async {
    try {
      final response = await _client.get('/chains');
      final chains = (response as List)
          .map((e) => ChainModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(chains);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch chains: $e'));
    }
  }

  @override
  Future<Either<Failure, ChainModel>> getChainById(String id) async {
    try {
      final response = await _client.get('/chains/$id');
      return right(ChainModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch chain: $e'));
    }
  }

  @override
  Future<Either<Failure, ChainModel>> createChain(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/chains', data: data);
      return right(ChainModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create chain: $e'));
    }
  }

  @override
  Future<Either<Failure, ChainModel>> updateChain(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/chains/$id', data: data);
      return right(ChainModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update chain: $e'));
    }
  }

  @override
  Future<Either<Failure, List<StoreModel>>> getChainStores(
    String chainId,
  ) async {
    try {
      final response = await _client.get('/chains/$chainId/stores');
      final stores = (response as List)
          .map((e) => StoreModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(stores);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch chain stores: $e'));
    }
  }
}
