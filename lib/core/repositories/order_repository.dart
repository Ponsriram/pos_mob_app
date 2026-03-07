import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

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

/// Order model — maps to backend OrderResponse
class OrderModel {
  final String id;
  final String storeId;
  final String? orderNumber;
  final String? employeeId;
  final String? terminalId;
  final String? tableId;
  final String? guestId;
  final String? shiftId;
  final OrderStatus status;
  final String orderType;
  final String channel;
  final double grossAmount;
  final double taxAmount;
  final double discountAmount;
  final double serviceCharge;
  final double tipAmount;
  final double netAmount;
  final String paymentStatus;
  final String? notes;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.storeId,
    this.orderNumber,
    this.employeeId,
    this.terminalId,
    this.tableId,
    this.guestId,
    this.shiftId,
    required this.status,
    this.orderType = 'dine_in',
    this.channel = 'pos',
    this.grossAmount = 0,
    this.taxAmount = 0,
    this.discountAmount = 0,
    this.serviceCharge = 0,
    this.tipAmount = 0,
    this.netAmount = 0,
    this.paymentStatus = 'pending',
    this.notes,
    this.cancelReason,
    required this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderNumber: json['order_number'] as String?,
      employeeId: json['employee_id']?.toString(),
      terminalId: json['terminal_id']?.toString(),
      tableId: json['table_id']?.toString(),
      guestId: json['guest_id']?.toString(),
      shiftId: json['shift_id']?.toString(),
      status: OrderStatusExtension.fromString(
        json['status'] as String? ?? 'pending',
      ),
      orderType: json['order_type'] as String? ?? 'dine_in',
      channel: json['channel'] as String? ?? 'pos',
      grossAmount: (json['gross_amount'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      serviceCharge: (json['service_charge'] as num?)?.toDouble() ?? 0,
      tipAmount: (json['tip_amount'] as num?)?.toDouble() ?? 0,
      netAmount: (json['net_amount'] as num?)?.toDouble() ?? 0,
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      cancelReason: json['cancel_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Backward-compatible getters
  double get totalAmount => netAmount;
  double get subtotal => grossAmount;
  OrderPlatform get platform => OrderPlatformExtension.fromString(orderType);
}

/// Order item model — maps to backend OrderItemResponse
class OrderItemModel {
  final String id;
  final String orderId;
  final String? productId;
  final int quantity;
  final double price;
  final double taxAmount;
  final double discountAmount;
  final double total;
  final String status;
  final String? notes;
  final String? kitchenStatus;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    this.productId,
    required this.quantity,
    required this.price,
    this.taxAmount = 0,
    this.discountAmount = 0,
    this.total = 0,
    this.status = 'active',
    this.notes,
    this.kitchenStatus,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id']?.toString(),
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'active',
      notes: json['notes'] as String?,
      kitchenStatus: json['kitchen_status'] as String?,
    );
  }

  /// Backward-compatible getters
  double get unitPrice => price;
  double get totalPrice => total;
  String get productName => ''; // Product name not in OrderItemResponse
}

/// Repository for order operations
abstract class OrderRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders({
    required String storeId,
    OrderStatus? status,
    String? orderType,
    String? channel,
    int limit,
    int offset,
  });

  Future<Either<Failure, List<OrderModel>>> getRunningOrders({
    required String storeId,
  });

  Future<Either<Failure, List<OrderModel>>> getOnlineOrders({
    required String storeId,
  });

  Future<Either<Failure, OrderModel>> getOrderById(String id);

  Future<Either<Failure, OrderModel>> createOrder({
    required Map<String, dynamic> orderData,
  });

  Future<Either<Failure, OrderModel>> updateOrderStatus({
    required String orderId,
    required dynamic status,
  });

  Future<Either<Failure, OrderModel>> cancelOrder({
    required String orderId,
    required String reason,
  });
}

/// REST API implementation of OrderRepository
class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _client;

  OrderRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders({
    required String storeId,
    OrderStatus? status,
    String? orderType,
    String? channel,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      if (status != null && status != OrderStatus.all) {
        queryParams['status'] = status.value;
      }
      if (orderType != null) {
        queryParams['order_type'] = orderType;
      }
      if (channel != null) {
        queryParams['channel'] = channel;
      }

      final response = await _client.get(
        '/orders',
        queryParameters: queryParams,
      );
      final orders = (response.data as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(orders);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch orders: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getRunningOrders({
    required String storeId,
  }) {
    // Running orders = pending + preparing + ready statuses
    return getOrders(storeId: storeId, status: OrderStatus.pending, limit: 200);
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getOnlineOrders({
    required String storeId,
  }) {
    return getOrders(storeId: storeId, channel: 'online', limit: 200);
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderById(String id) async {
    try {
      final response = await _client.get('/orders/$id');
      return right(OrderModel.fromJson(response.data as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch order: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> createOrder({
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final response = await _client.post('/orders', data: orderData);
      return right(OrderModel.fromJson(response.data as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create order: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> updateOrderStatus({
    required String orderId,
    required dynamic status,
  }) async {
    try {
      final statusStr = status is OrderStatus
          ? status.value
          : status.toString();
      final response = await _client.put(
        '/orders/$orderId/status',
        data: {'status': statusStr},
      );
      return right(OrderModel.fromJson(response.data as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to update order status: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      final response = await _client.put(
        '/orders/$orderId/cancel',
        data: {'reason': reason},
      );
      return right(OrderModel.fromJson(response.data as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to cancel order: $e'));
    }
  }
}
