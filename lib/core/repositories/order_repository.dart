import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/core/error/failure.dart';

/// Order status enum
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  completed,
  cancelled,
  all,
}

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.ready:
        return 'ready';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.all:
        return 'all';
    }
  }

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Order platform enum
enum OrderPlatform {
  dineIn,
  takeaway,
  delivery,
  swiggy,
  zomato,
  foodpanda,
  uberEats,
  all,
}

extension OrderPlatformExtension on OrderPlatform {
  String get value {
    switch (this) {
      case OrderPlatform.dineIn:
        return 'dine_in';
      case OrderPlatform.takeaway:
        return 'takeaway';
      case OrderPlatform.delivery:
        return 'delivery';
      case OrderPlatform.swiggy:
        return 'swiggy';
      case OrderPlatform.zomato:
        return 'zomato';
      case OrderPlatform.foodpanda:
        return 'foodpanda';
      case OrderPlatform.uberEats:
        return 'uber_eats';
      case OrderPlatform.all:
        return 'all';
    }
  }

  String get displayName {
    switch (this) {
      case OrderPlatform.dineIn:
        return 'Dine In';
      case OrderPlatform.takeaway:
        return 'Takeaway';
      case OrderPlatform.delivery:
        return 'Delivery';
      case OrderPlatform.swiggy:
        return 'Swiggy';
      case OrderPlatform.zomato:
        return 'Zomato';
      case OrderPlatform.foodpanda:
        return 'Foodpanda';
      case OrderPlatform.uberEats:
        return 'Uber Eats';
      case OrderPlatform.all:
        return 'All Platforms';
    }
  }

  static OrderPlatform fromString(String value) {
    return OrderPlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderPlatform.dineIn,
    );
  }
}

/// Order model
class OrderModel {
  final String id;
  final String storeId;
  final String orderNumber;
  final String? customerId;
  final String? customerName;
  final String? tableId;
  final String? tableName;
  final OrderStatus status;
  final OrderPlatform platform;
  final String? platformOrderId;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final String? notes;
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.storeId,
    required this.orderNumber,
    this.customerId,
    this.customerName,
    this.tableId,
    this.tableName,
    required this.status,
    required this.platform,
    this.platformOrderId,
    this.subtotal = 0,
    this.taxAmount = 0,
    this.discountAmount = 0,
    this.totalAmount = 0,
    this.notes,
    required this.createdAt,
    this.completedAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderNumber: json['order_number'] as String,
      customerId: json['customer_id'] as String?,
      customerName:
          json['customer_name'] as String? ??
          (json['customer'] as Map<String, dynamic>?)?['name'] as String?,
      tableId: json['table_id'] as String?,
      tableName:
          json['table_name'] as String? ??
          (json['restaurant_table'] as Map<String, dynamic>?)?['name']
              as String?,
      status: OrderStatusExtension.fromString(json['status'] as String),
      platform: OrderPlatformExtension.fromString(
        json['order_type'] as String? ?? 'dine_in',
      ),
      platformOrderId: json['platform_order_id'] as String?,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      items:
          (json['order_items'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// Order item model
class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String? variantId;
  final String? variantName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? notes;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.variantId,
    this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName:
          json['product_name'] as String? ??
          (json['product'] as Map<String, dynamic>?)?['name'] as String? ??
          'Unknown',
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
    );
  }
}

/// Repository for order operations
abstract class OrderRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders({
    required String storeId,
    OrderStatus? status,
    OrderPlatform? platform,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    int offset = 0,
  });

  Future<Either<Failure, List<OrderModel>>> getRunningOrders({
    required String storeId,
  });

  Future<Either<Failure, List<OrderModel>>> getOnlineOrders({
    required String storeId,
    OrderStatus? status,
    OrderPlatform? platform,
  });

  Future<Either<Failure, OrderModel>> getOrderById(String id);

  Future<Either<Failure, OrderModel>> createOrder({
    required String storeId,
    required Map<String, dynamic> orderData,
    required List<Map<String, dynamic>> items,
  });

  Future<Either<Failure, OrderModel>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  Stream<List<OrderModel>> watchRunningOrders(String storeId);
}

/// Supabase implementation of OrderRepository
class OrderRepositoryImpl implements OrderRepository {
  final SupabaseClient _client;

  OrderRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders({
    required String storeId,
    OrderStatus? status,
    OrderPlatform? platform,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = _client
          .from('orders')
          .select('*, order_items(*, product:products(name))')
          .eq('store_id', storeId);

      if (status != null && status != OrderStatus.all) {
        query = query.eq('status', status.value);
      }

      if (platform != null && platform != OrderPlatform.all) {
        query = query.eq('order_type', platform.value);
      }

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final orders = (response as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
      return right(orders);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch orders: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getRunningOrders({
    required String storeId,
  }) async {
    try {
      final response = await _client
          .from('orders')
          .select('*, order_items(*, product:products(name))')
          .eq('store_id', storeId)
          .inFilter('status', ['pending', 'confirmed', 'preparing', 'ready'])
          .order('created_at', ascending: false);

      final orders = (response as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
      return right(orders);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch running orders: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getOnlineOrders({
    required String storeId,
    OrderStatus? status,
    OrderPlatform? platform,
  }) async {
    try {
      var query = _client
          .from('orders')
          .select('*, order_items(*, product:products(name))')
          .eq('store_id', storeId)
          .inFilter('order_type', [
            'swiggy',
            'zomato',
            'foodpanda',
            'uber_eats',
          ]);

      if (status != null && status != OrderStatus.all) {
        query = query.eq('status', status.value);
      }

      if (platform != null && platform != OrderPlatform.all) {
        query = query.eq('order_type', platform.value);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(100);

      final orders = (response as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
      return right(orders);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch online orders: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderById(String id) async {
    try {
      final response = await _client
          .from('orders')
          .select('*, order_items(*, product:products(name))')
          .eq('id', id)
          .single();

      return right(OrderModel.fromJson(response));
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch order: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> createOrder({
    required String storeId,
    required Map<String, dynamic> orderData,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await _client.rpc(
        'create_order_with_items',
        params: {
          'p_store_id': storeId,
          'p_order_data': orderData,
          'p_items': items,
        },
      );

      if (response == null) {
        return left(const Failure(message: 'Failed to create order'));
      }

      // Fetch the created order with items
      return getOrderById(response['id'] as String);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to create order: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      await _client
          .from('orders')
          .update({
            'status': status.value,
            if (status == OrderStatus.completed)
              'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);

      return getOrderById(orderId);
    } on PostgrestException catch (e) {
      return left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return left(Failure(message: 'Failed to update order status: $e'));
    }
  }

  @override
  Stream<List<OrderModel>> watchRunningOrders(String storeId) {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('store_id', storeId)
        .order('created_at', ascending: false)
        .map(
          (data) => data
              .where(
                (e) => [
                  'pending',
                  'confirmed',
                  'preparing',
                  'ready',
                ].contains(e['status']),
              )
              .map((e) => OrderModel.fromJson(e))
              .toList(),
        );
  }
}
