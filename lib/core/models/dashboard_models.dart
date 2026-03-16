// Stub data models for dashboard — no business logic, no network calls.
// These replace the models previously defined in core/repositories/.

class DashboardStats {
  final double totalSales;
  final double netSales;
  final int totalOrders;
  final double grossSales;
  final double taxCollected;
  final double totalDiscounts;
  final double cashSales;
  final double cardSales;
  final double upiSales;
  final double onlineSales;

  const DashboardStats({
    this.totalSales = 0,
    this.netSales = 0,
    this.totalOrders = 0,
    this.grossSales = 0,
    this.taxCollected = 0,
    this.totalDiscounts = 0,
    this.cashSales = 0,
    this.cardSales = 0,
    this.upiSales = 0,
    this.onlineSales = 0,
  });

  static const empty = DashboardStats();

  double get averageOrderValue =>
      totalOrders > 0 ? totalSales / totalOrders : 0;

  int get completedOrders => totalOrders;
}

class OutletStats {
  final String storeId;
  final String storeName;
  final int totalOrders;
  final double totalSales;
  final double netSales;

  const OutletStats({
    required this.storeId,
    required this.storeName,
    this.totalOrders = 0,
    this.totalSales = 0,
    this.netSales = 0,
  });
}

class StoreModel {
  final String id;
  final String name;
  final String? location;

  const StoreModel({required this.id, required this.name, this.location});

  String? get address => location;
}
