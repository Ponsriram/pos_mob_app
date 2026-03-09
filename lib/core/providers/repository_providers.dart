import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/providers/auth_provider.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';
import 'package:pos_app/core/repositories/store_repository.dart';
import 'package:pos_app/core/repositories/dashboard_repository.dart';
import 'package:pos_app/core/repositories/order_repository.dart';
import 'package:pos_app/core/repositories/profile_repository.dart';
import 'package:pos_app/core/repositories/sales_report_repository.dart';
import 'package:pos_app/core/repositories/zone_repository.dart';
import 'package:pos_app/core/repositories/group_repository.dart';
import 'package:pos_app/core/repositories/employee_repository.dart';
import 'package:pos_app/core/repositories/product_repository.dart';
import 'package:pos_app/core/repositories/integration_repository.dart';
import 'package:pos_app/core/repositories/notification_repository.dart';
import 'package:pos_app/core/repositories/purchasing_repository.dart';
import 'package:pos_app/core/repositories/chain_repository.dart';
import 'package:pos_app/core/repositories/user_repository.dart';
import 'package:pos_app/core/repositories/report_repository.dart';
import 'package:pos_app/core/repositories/shift_repository.dart';
import 'package:pos_app/core/repositories/billing_repository.dart';
import 'package:pos_app/core/repositories/delivery_repository.dart';
import 'package:pos_app/core/repositories/guest_repository.dart';
import 'package:pos_app/core/repositories/inventory_repository.dart';
import 'package:pos_app/core/repositories/ledger_repository.dart';
import 'package:pos_app/core/repositories/marketing_repository.dart';
import 'package:pos_app/core/repositories/menu_repository.dart';
import 'package:pos_app/core/repositories/audit_repository.dart';

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

/// Zone repository provider
@riverpod
ZoneRepository zoneRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return ZoneRepositoryImpl(client);
}

/// Group repository provider
@riverpod
GroupRepository groupRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return GroupRepositoryImpl(client);
}

/// Employee repository provider
@riverpod
EmployeeRepository employeeRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return EmployeeRepositoryImpl(client);
}

/// Product repository provider
@riverpod
ProductRepository productRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return ProductRepositoryImpl(client);
}

/// Integration repository provider
@riverpod
IntegrationRepository integrationRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return IntegrationRepositoryImpl(client);
}

/// Notification repository provider
@riverpod
NotificationRepository notificationRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return NotificationRepositoryImpl(client);
}

/// Purchasing repository provider
@riverpod
PurchasingRepository purchasingRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return PurchasingRepositoryImpl(client);
}

/// Chain repository provider
@riverpod
ChainRepository chainRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return ChainRepositoryImpl(client);
}

/// User repository provider
@riverpod
UserRepository userRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return UserRepositoryImpl(client);
}

/// Report repository provider
@riverpod
ReportRepository reportRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return ReportRepositoryImpl(client);
}

/// Shift repository provider
@riverpod
ShiftRepository shiftRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return ShiftRepositoryImpl(client);
}

/// Billing repository provider
@riverpod
BillingRepository billingRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return BillingRepositoryImpl(client);
}

/// Delivery repository provider
@riverpod
DeliveryRepository deliveryRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return DeliveryRepositoryImpl(client);
}

/// Guest repository provider
@riverpod
GuestRepository guestRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return GuestRepositoryImpl(client);
}

/// Inventory repository provider
@riverpod
InventoryRepository inventoryRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return InventoryRepositoryImpl(client);
}

/// Ledger repository provider
@riverpod
LedgerRepository ledgerRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return LedgerRepositoryImpl(client);
}

/// Marketing repository provider
@riverpod
MarketingRepository marketingRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return MarketingRepositoryImpl(client);
}

/// Menu repository provider
@riverpod
MenuRepository menuRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return MenuRepositoryImpl(client);
}

/// Audit repository provider
@riverpod
AuditRepository auditRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return AuditRepositoryImpl(client);
}
