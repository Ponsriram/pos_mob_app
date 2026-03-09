import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';
import 'package:pos_app/features/more/model/report_model.dart';

abstract class ReportRepository {
  Future<Either<Failure, List<ReportModel>>> getReportTemplates({
    String? category,
  });
}

class ReportRepositoryImpl implements ReportRepository {
  final ApiClient _client;
  ReportRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<ReportModel>>> getReportTemplates({
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;

      final data = await _client.get(
        '/reports/types',
        queryParameters: queryParams,
      );
      final list = (data as List)
          .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
