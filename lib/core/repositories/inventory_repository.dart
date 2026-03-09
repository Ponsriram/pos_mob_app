import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Models ─────────────────────────────────────────────

class InventoryUnitModel {
  final String id;
  final String storeId;
  final String name;
  final String abbreviation;
  final String? baseUnitId;
  final double conversionFactor;

  const InventoryUnitModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.abbreviation,
    this.baseUnitId,
    required this.conversionFactor,
  });

  factory InventoryUnitModel.fromJson(Map<String, dynamic> json) {
    return InventoryUnitModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      abbreviation: json['abbreviation'] as String? ?? '',
      baseUnitId: json['base_unit_id'] as String?,
      conversionFactor: (json['conversion_factor'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class InventoryLocationModel {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final bool isActive;

  const InventoryLocationModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    required this.isActive,
  });

  factory InventoryLocationModel.fromJson(Map<String, dynamic> json) {
    return InventoryLocationModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class InventoryItemModel {
  final String id;
  final String storeId;
  final String name;
  final String? sku;
  final String? category;
  final String unitId;
  final double minStock;
  final double? maxStock;
  final double reorderLevel;
  final double? reorderQuantity;
  final double? lastPurchasePrice;
  final double? averageCost;
  final String? preferredVendorId;
  final List<dynamic>? tags;
  final bool isActive;
  final DateTime createdAt;

  const InventoryItemModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.sku,
    this.category,
    required this.unitId,
    required this.minStock,
    this.maxStock,
    required this.reorderLevel,
    this.reorderQuantity,
    this.lastPurchasePrice,
    this.averageCost,
    this.preferredVendorId,
    this.tags,
    required this.isActive,
    required this.createdAt,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String?,
      category: json['category'] as String?,
      unitId: json['unit_id'] as String,
      minStock: (json['min_stock'] as num?)?.toDouble() ?? 0,
      maxStock: (json['max_stock'] as num?)?.toDouble(),
      reorderLevel: (json['reorder_level'] as num?)?.toDouble() ?? 0,
      reorderQuantity: (json['reorder_quantity'] as num?)?.toDouble(),
      lastPurchasePrice: (json['last_purchase_price'] as num?)?.toDouble(),
      averageCost: (json['average_cost'] as num?)?.toDouble(),
      preferredVendorId: json['preferred_vendor_id'] as String?,
      tags: json['tags'] as List?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

class StockLevelModel {
  final String id;
  final String itemId;
  final String locationId;
  final double quantity;
  final DateTime updatedAt;

  const StockLevelModel({
    required this.id,
    required this.itemId,
    required this.locationId,
    required this.quantity,
    required this.updatedAt,
  });

  factory StockLevelModel.fromJson(Map<String, dynamic> json) {
    return StockLevelModel(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      locationId: json['location_id'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

class StockAdjustmentModel {
  final String id;
  final String storeId;
  final String itemId;
  final String locationId;
  final double quantityChange;
  final String reason;
  final String? notes;
  final String? adjustedBy;
  final DateTime createdAt;

  const StockAdjustmentModel({
    required this.id,
    required this.storeId,
    required this.itemId,
    required this.locationId,
    required this.quantityChange,
    required this.reason,
    this.notes,
    this.adjustedBy,
    required this.createdAt,
  });

  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) {
    return StockAdjustmentModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      itemId: json['item_id'] as String,
      locationId: json['location_id'] as String,
      quantityChange: (json['quantity_change'] as num?)?.toDouble() ?? 0,
      reason: json['reason'] as String? ?? '',
      notes: json['notes'] as String?,
      adjustedBy: json['adjusted_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

class RecipeLineModel {
  final String id;
  final String recipeId;
  final String ingredientId;
  final double quantity;
  final String unitId;

  const RecipeLineModel({
    required this.id,
    required this.recipeId,
    required this.ingredientId,
    required this.quantity,
    required this.unitId,
  });

  factory RecipeLineModel.fromJson(Map<String, dynamic> json) {
    return RecipeLineModel(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String,
      ingredientId: json['ingredient_id'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unitId: json['unit_id'] as String,
    );
  }
}

class RecipeModel {
  final String id;
  final String storeId;
  final String productId;
  final String name;
  final String? description;
  final double yieldQuantity;
  final double wastagePercent;
  final bool isActive;
  final DateTime createdAt;
  final List<RecipeLineModel> lines;

  const RecipeModel({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.name,
    this.description,
    required this.yieldQuantity,
    required this.wastagePercent,
    required this.isActive,
    required this.createdAt,
    this.lines = const [],
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      yieldQuantity: (json['yield_quantity'] as num?)?.toDouble() ?? 1,
      wastagePercent: (json['wastage_percent'] as num?)?.toDouble() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      lines:
          (json['lines'] as List?)
              ?.map((e) => RecipeLineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class StockTransferModel {
  final String id;
  final String fromStoreId;
  final String toStoreId;
  final String status;
  final String? notes;
  final String? requestedBy;
  final String? approvedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StockTransferModel({
    required this.id,
    required this.fromStoreId,
    required this.toStoreId,
    required this.status,
    this.notes,
    this.requestedBy,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StockTransferModel.fromJson(Map<String, dynamic> json) {
    return StockTransferModel(
      id: json['id'] as String,
      fromStoreId: json['from_store_id'] as String,
      toStoreId: json['to_store_id'] as String,
      status: json['status'] as String? ?? 'requested',
      notes: json['notes'] as String?,
      requestedBy: json['requested_by'] as String?,
      approvedBy: json['approved_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class InventoryRepository {
  // Units
  Future<Either<Failure, InventoryUnitModel>> createUnit(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<InventoryUnitModel>>> listUnits({
    required String storeId,
  });

  // Locations
  Future<Either<Failure, InventoryLocationModel>> createLocation(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<InventoryLocationModel>>> listLocations({
    required String storeId,
  });

  // Items
  Future<Either<Failure, InventoryItemModel>> createItem(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<InventoryItemModel>>> listItems({
    required String storeId,
    bool activeOnly = true,
  });
  Future<Either<Failure, InventoryItemModel>> updateItem(
    String itemId,
    Map<String, dynamic> data,
  );

  // Stock Levels
  Future<Either<Failure, List<StockLevelModel>>> getStockLevels({
    required String storeId,
  });

  // Stock Adjustments
  Future<Either<Failure, StockAdjustmentModel>> adjustStock(
    Map<String, dynamic> data,
  );

  // Recipes
  Future<Either<Failure, RecipeModel>> createRecipe(Map<String, dynamic> data);
  Future<Either<Failure, RecipeModel>> getRecipe(String recipeId);
  Future<Either<Failure, RecipeModel>> updateRecipe(
    String recipeId,
    Map<String, dynamic> data,
  );

  // Stock Transfers
  Future<Either<Failure, StockTransferModel>> createTransfer(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, StockTransferModel>> updateTransferStatus(
    String transferId,
    Map<String, dynamic> data,
  );

  // Out of Stock
  Future<Either<Failure, List<InventoryItemModel>>> listOutOfStock({
    required String storeId,
  });
  Future<Either<Failure, InventoryItemModel>> toggleAvailability(
    String itemId,
    Map<String, dynamic> data,
  );
}

// ── Implementation ─────────────────────────────────────

class InventoryRepositoryImpl implements InventoryRepository {
  final ApiClient _client;
  InventoryRepositoryImpl(this._client);

  // ── Units ──

  @override
  Future<Either<Failure, InventoryUnitModel>> createUnit(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/inventory/units', data: data);
      return right(
        InventoryUnitModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<InventoryUnitModel>>> listUnits({
    required String storeId,
  }) async {
    try {
      final data = await _client.get(
        '/inventory/units',
        queryParameters: {'store_id': storeId},
      );
      final list = (data as List)
          .map((e) => InventoryUnitModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Locations ──

  @override
  Future<Either<Failure, InventoryLocationModel>> createLocation(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/inventory/locations', data: data);
      return right(
        InventoryLocationModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<InventoryLocationModel>>> listLocations({
    required String storeId,
  }) async {
    try {
      final data = await _client.get(
        '/inventory/locations',
        queryParameters: {'store_id': storeId},
      );
      final list = (data as List)
          .map(
            (e) => InventoryLocationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Items ──

  @override
  Future<Either<Failure, InventoryItemModel>> createItem(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/inventory/items', data: data);
      return right(
        InventoryItemModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<InventoryItemModel>>> listItems({
    required String storeId,
    bool activeOnly = true,
  }) async {
    try {
      final data = await _client.get(
        '/inventory/items',
        queryParameters: {'store_id': storeId, 'active_only': activeOnly},
      );
      final list = (data as List)
          .map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, InventoryItemModel>> updateItem(
    String itemId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/inventory/items/$itemId',
        data: data,
      );
      return right(
        InventoryItemModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Stock Levels ──

  @override
  Future<Either<Failure, List<StockLevelModel>>> getStockLevels({
    required String storeId,
  }) async {
    try {
      final data = await _client.get(
        '/inventory/stock',
        queryParameters: {'store_id': storeId},
      );
      final list = (data as List)
          .map((e) => StockLevelModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Stock Adjustments ──

  @override
  Future<Either<Failure, StockAdjustmentModel>> adjustStock(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post(
        '/inventory/stock/adjustments',
        data: data,
      );
      return right(
        StockAdjustmentModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Recipes ──

  @override
  Future<Either<Failure, RecipeModel>> createRecipe(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/inventory/recipes', data: data);
      return right(RecipeModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, RecipeModel>> getRecipe(String recipeId) async {
    try {
      final response = await _client.get('/inventory/recipes/$recipeId');
      return right(RecipeModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, RecipeModel>> updateRecipe(
    String recipeId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/inventory/recipes/$recipeId',
        data: data,
      );
      return right(RecipeModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Stock Transfers ──

  @override
  Future<Either<Failure, StockTransferModel>> createTransfer(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/inventory/transfers', data: data);
      return right(
        StockTransferModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, StockTransferModel>> updateTransferStatus(
    String transferId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/inventory/transfers/$transferId/status',
        data: data,
      );
      return right(
        StockTransferModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Out of Stock ──

  @override
  Future<Either<Failure, List<InventoryItemModel>>> listOutOfStock({
    required String storeId,
  }) async {
    try {
      final data = await _client.get(
        '/inventory/out-of-stock',
        queryParameters: {'store_id': storeId},
      );
      final list = (data as List)
          .map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, InventoryItemModel>> toggleAvailability(
    String itemId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/inventory/items/$itemId/availability',
        data: data,
      );
      return right(
        InventoryItemModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
