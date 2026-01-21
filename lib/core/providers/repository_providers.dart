import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/supabase_provider.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/dashboard_repository.dart';
import 'package:pos_app/core/repositories/order_repository.dart';

part 'repository_providers.g.dart';

/// Store repository provider
@riverpod
StoreRepository storeRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return StoreRepositoryImpl(client);
}

/// Dashboard repository provider
@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return DashboardRepositoryImpl(client);
}

/// Order repository provider
@riverpod
OrderRepository orderRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return OrderRepositoryImpl(client);
}
