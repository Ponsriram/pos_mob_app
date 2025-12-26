/// Model class representing an order category with statistics
class OrderCategoryModel {
  final String title;
  final String subtitle;
  final int orderCount;
  final double estimatedAmount;
  final OrderCategoryType type;

  const OrderCategoryModel({
    required this.title,
    required this.subtitle,
    required this.orderCount,
    required this.estimatedAmount,
    required this.type,
  });

  /// Returns default order categories for the Running Orders screen
  static List<OrderCategoryModel> getDefaultCategories() {
    return [
      const OrderCategoryModel(
        title: 'Dine In',
        subtitle: 'Orders / KOTS',
        orderCount: 0,
        estimatedAmount: 0.00,
        type: OrderCategoryType.dineIn,
      ),
      const OrderCategoryModel(
        title: 'Pick Up',
        subtitle: 'Orders',
        orderCount: 0,
        estimatedAmount: 0.00,
        type: OrderCategoryType.pickUp,
      ),
      const OrderCategoryModel(
        title: 'Delivery',
        subtitle: 'Orders',
        orderCount: 0,
        estimatedAmount: 0.00,
        type: OrderCategoryType.delivery,
      ),
      const OrderCategoryModel(
        title: 'Order yet to be marked ready',
        subtitle: 'Orders',
        orderCount: 0,
        estimatedAmount: 0.00,
        type: OrderCategoryType.yetToBeMarkedReady,
      ),
      const OrderCategoryModel(
        title: 'Order yet to be picked up',
        subtitle: 'Orders',
        orderCount: 0,
        estimatedAmount: 0.00,
        type: OrderCategoryType.yetToBePickedUp,
      ),
      const OrderCategoryModel(
        title: 'Order yet to be delivered',
        subtitle: 'Orders',
        orderCount: 0,
        estimatedAmount: 0.00,
        type: OrderCategoryType.yetToBeDelivered,
      ),
    ];
  }
}

/// Enum representing different order category types
enum OrderCategoryType {
  dineIn,
  pickUp,
  delivery,
  yetToBeMarkedReady,
  yetToBePickedUp,
  yetToBeDelivered,
}
