import 'package:flutter/material.dart';

/// Model for online order platform tabs
class OrderPlatformModel {
  final String id;
  final String name;
  final String? iconUrl;
  final IconData? icon;
  final Color? brandColor;

  const OrderPlatformModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.icon,
    this.brandColor,
  });

  /// Default platform options (these are UI configuration, not data)
  static const List<OrderPlatformModel> defaultPlatforms = [
    OrderPlatformModel(id: 'all', name: 'All', icon: Icons.grid_view_outlined),
    OrderPlatformModel(
      id: 'foodpanda',
      name: 'FoodPanda',
      icon: Icons.delivery_dining,
    ),
    OrderPlatformModel(id: 'zomato', name: 'Zomato', icon: Icons.restaurant),
    OrderPlatformModel(id: 'swiggy', name: 'Swiggy', icon: Icons.fastfood),
    OrderPlatformModel(
      id: 'uber_eats',
      name: 'Uber Eats',
      icon: Icons.directions_car,
    ),

    OrderPlatformModel(
      id: 'dine_in',
      name: 'Dine In',
      icon: Icons.restaurant_menu,
    ),
    OrderPlatformModel(
      id: 'takeaway',
      name: 'Takeaway',
      icon: Icons.shopping_bag,
    ),
    OrderPlatformModel(
      id: 'delivery',
      name: 'Delivery',
      icon: Icons.delivery_dining,
    ),
  ];
}

/// Model for order status filter
enum OrderStatus {
  all('All'),
  waitingForAcceptance('Waiting For Acceptance'),
  accepted('Accepted'),
  preparingFoodKotCreated('Preparing Food/KOT Created'),
  preparingBillCreated('Preparing/Bill Created'),
  foodIsReady('Food Is Ready'),
  dispatched('Dispatched'),
  delivered('Delivered');

  final String displayName;
  const OrderStatus(this.displayName);
}

/// Model for record type filter
enum RecordType {
  getOldRecords('Get old records'),
  last2DaysRecords('Last 2 days records'),
  last5DaysRecords('Last 5 days records'),
  last7DaysRecords('Last 7 days records');

  final String displayName;
  const RecordType(this.displayName);
}

/// Model for restaurant selection
class RestaurantModel {
  final String id;
  final String name;

  const RestaurantModel({required this.id, required this.name});

  String get displayName => '$name';
}

/// Model for online order record
class OnlineOrderModel {
  final String orderNo;
  final String outletName;
  final String orderFrom;
  final String orderType;
  final String? riderDetails;
  final String customerName;
  final String? customerPhone;
  final String? otp;
  final DateTime dateTime;
  final double total;
  final OrderStatus status;

  const OnlineOrderModel({
    required this.orderNo,
    required this.outletName,
    required this.orderFrom,
    required this.orderType,
    this.riderDetails,
    required this.customerName,
    this.customerPhone,
    this.otp,
    required this.dateTime,
    required this.total,
    required this.status,
  });
}

/// Model for chart data point
class ChartDataPoint {
  final DateTime date;
  final String platformId;
  final int orderCount;

  const ChartDataPoint({
    required this.date,
    required this.platformId,
    required this.orderCount,
  });
}

/// Model for chart legend item
class ChartLegendItem {
  final String platformName;
  final Color color;

  const ChartLegendItem({required this.platformName, required this.color});
}
