import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/auth_provider.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/dashboard_repository.dart';
import 'package:pos_app/core/repositories/order_repository.dart';
import 'package:pos_app/core/repositories/profile_repository.dart';
import 'package:pos_app/core/repositories/sales_report_repository.dart';

part 'repository_providers.g.dart';

/// Store repository provider
@riverpod
StoreRepository storeRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return StoreRepositoryImpl(client);
}

/// Dashboard repository provider
@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return DashboardRepositoryImpl(client);
}

/// Order repository provider
@riverpod
OrderRepository orderRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return OrderRepositoryImpl(client);
}

/// Profile repository provider
@riverpod
ProfileRepository profileRepository(Ref ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return ProfileRepositoryImpl(localStorage);
}

/// Sales report repository provider
@riverpod
SalesReportRepository salesReportRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return SalesReportRepositoryImpl(client);
}
