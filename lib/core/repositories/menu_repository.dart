import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Models ─────────────────────────────────────────────

class MenuScheduleModel {
  final String id;
  final String menuId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  const MenuScheduleModel({
    required this.id,
    required this.menuId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory MenuScheduleModel.fromJson(Map<String, dynamic> json) {
    return MenuScheduleModel(
      id: json['id'] as String,
      menuId: json['menu_id'] as String,
      dayOfWeek: json['day_of_week'] as int? ?? 0,
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
    );
  }
}

class MenuItemModel {
  final String id;
  final String menuId;
  final String productId;
  final String? displayName;
  final String? descriptionOverride;
  final double? priceOverride;
  final double? taxPercentOverride;
  final int sortOrder;
  final bool isVisible;
  final bool isAvailable;
  final List<dynamic>? tags;

  const MenuItemModel({
    required this.id,
    required this.menuId,
    required this.productId,
    this.displayName,
    this.descriptionOverride,
    this.priceOverride,
    this.taxPercentOverride,
    required this.sortOrder,
    required this.isVisible,
    required this.isAvailable,
    this.tags,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      menuId: json['menu_id'] as String,
      productId: json['product_id'] as String,
      displayName: json['display_name'] as String?,
      descriptionOverride: json['description_override'] as String?,
      priceOverride: (json['price_override'] as num?)?.toDouble(),
      taxPercentOverride: (json['tax_percent_override'] as num?)?.toDouble(),
      sortOrder: json['sort_order'] as int? ?? 0,
      isVisible: json['is_visible'] as bool? ?? true,
      isAvailable: json['is_available'] as bool? ?? true,
      tags: json['tags'] as List?,
    );
  }
}

class MenuModel {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final String menuType;
  final bool isActive;
  final String? validFrom;
  final String? validUntil;
  final List<dynamic>? channels;
  final int sortOrder;
  final DateTime createdAt;
  final List<MenuItemModel> items;
  final List<MenuScheduleModel> schedules;

  const MenuModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    required this.menuType,
    required this.isActive,
    this.validFrom,
    this.validUntil,
    this.channels,
    required this.sortOrder,
    required this.createdAt,
    this.items = const [],
    this.schedules = const [],
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      menuType: json['menu_type'] as String? ?? 'all_day',
      isActive: json['is_active'] as bool? ?? true,
      validFrom: json['valid_from'] as String?,
      validUntil: json['valid_until'] as String?,
      channels: json['channels'] as List?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      items:
          (json['items'] as List?)
              ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      schedules:
          (json['schedules'] as List?)
              ?.map(
                (e) => MenuScheduleModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class MenuPricingRuleModel {
  final String id;
  final String storeId;
  final String? menuItemId;
  final String? productId;
  final String name;
  final String ruleType;
  final String? channel;
  final int? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final String? validFrom;
  final String? validUntil;
  final double? fixedPrice;
  final double? discountPercent;
  final int priority;
  final bool isActive;

  const MenuPricingRuleModel({
    required this.id,
    required this.storeId,
    this.menuItemId,
    this.productId,
    required this.name,
    required this.ruleType,
    this.channel,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.validFrom,
    this.validUntil,
    this.fixedPrice,
    this.discountPercent,
    required this.priority,
    required this.isActive,
  });

  factory MenuPricingRuleModel.fromJson(Map<String, dynamic> json) {
    return MenuPricingRuleModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      menuItemId: json['menu_item_id'] as String?,
      productId: json['product_id'] as String?,
      name: json['name'] as String? ?? '',
      ruleType: json['rule_type'] as String? ?? '',
      channel: json['channel'] as String?,
      dayOfWeek: json['day_of_week'] as int?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      validFrom: json['valid_from'] as String?,
      validUntil: json['valid_until'] as String?,
      fixedPrice: (json['fixed_price'] as num?)?.toDouble(),
      discountPercent: (json['discount_percent'] as num?)?.toDouble(),
      priority: json['priority'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class MenuRepository {
  // Menus
  Future<Either<Failure, MenuModel>> createMenu(Map<String, dynamic> data);
  Future<Either<Failure, List<MenuModel>>> listMenus({
    required String storeId,
    bool activeOnly = true,
  });
  Future<Either<Failure, MenuModel>> getMenu(String menuId);
  Future<Either<Failure, MenuModel>> updateMenu(
    String menuId,
    Map<String, dynamic> data,
  );

  // Menu Items
  Future<Either<Failure, MenuItemModel>> createMenuItem(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, MenuItemModel>> updateMenuItem(
    String itemId,
    Map<String, dynamic> data,
  );

  // Schedules
  Future<Either<Failure, List<MenuScheduleModel>>> setSchedules(
    String menuId,
    List<Map<String, dynamic>> schedules,
  );

  // Pricing Rules
  Future<Either<Failure, MenuPricingRuleModel>> createPricingRule(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, MenuPricingRuleModel>> updatePricingRule(
    String ruleId,
    Map<String, dynamic> data,
  );
}

// ── Implementation ─────────────────────────────────────

class MenuRepositoryImpl implements MenuRepository {
  final ApiClient _client;
  MenuRepositoryImpl(this._client);

  // ── Menus ──

  @override
  Future<Either<Failure, MenuModel>> createMenu(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/menus', data: data);
      return right(MenuModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MenuModel>>> listMenus({
    required String storeId,
    bool activeOnly = true,
  }) async {
    try {
      final data = await _client.get(
        '/menus',
        queryParameters: {'store_id': storeId, 'active_only': activeOnly},
      );
      final list = (data as List)
          .map((e) => MenuModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, MenuModel>> getMenu(String menuId) async {
    try {
      final response = await _client.get('/menus/$menuId');
      return right(MenuModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, MenuModel>> updateMenu(
    String menuId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/menus/$menuId', data: data);
      return right(MenuModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Menu Items ──

  @override
  Future<Either<Failure, MenuItemModel>> createMenuItem(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/menus/items', data: data);
      return right(MenuItemModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, MenuItemModel>> updateMenuItem(
    String itemId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put('/menus/items/$itemId', data: data);
      return right(MenuItemModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Schedules ──

  @override
  Future<Either<Failure, List<MenuScheduleModel>>> setSchedules(
    String menuId,
    List<Map<String, dynamic>> schedules,
  ) async {
    try {
      final data = await _client.put(
        '/menus/$menuId/schedules',
        data: schedules,
      );
      final list = (data as List)
          .map((e) => MenuScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Pricing Rules ──

  @override
  Future<Either<Failure, MenuPricingRuleModel>> createPricingRule(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/menus/pricing-rules', data: data);
      return right(
        MenuPricingRuleModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, MenuPricingRuleModel>> updatePricingRule(
    String ruleId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/menus/pricing-rules/$ruleId',
        data: data,
      );
      return right(
        MenuPricingRuleModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
