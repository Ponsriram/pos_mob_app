/// Model representing the dashboard statistics data
class DashboardStatsModel {
  final String totalSales;
  final int totalOutlets;
  final int totalOrders;
  final String onlineSales;
  final String onlineSalesPercent;
  final String cashCollected;
  final String cashCollectedPercent;
  final String netSales;
  final int netSalesOutlets;
  final String expenses;
  final String taxes;
  final String discounts;
  final String discountsPercent;

  const DashboardStatsModel({
    required this.totalSales,
    required this.totalOutlets,
    required this.totalOrders,
    required this.onlineSales,
    required this.onlineSalesPercent,
    required this.cashCollected,
    required this.cashCollectedPercent,
    required this.netSales,
    required this.netSalesOutlets,
    required this.expenses,
    required this.taxes,
    required this.discounts,
    required this.discountsPercent,
  });

  /// Factory constructor for creating a default/sample instance
  factory DashboardStatsModel.sample() {
    return const DashboardStatsModel(
      totalSales: '32,266.00',
      totalOutlets: 2,
      totalOrders: 67,
      onlineSales: '0.00',
      onlineSalesPercent: '0%',
      cashCollected: '32,266.00',
      cashCollectedPercent: '100.00%',
      netSales: '30,742.57',
      netSalesOutlets: 2,
      expenses: '0.00',
      taxes: '1,524.54',
      discounts: '0.00',
      discountsPercent: '0%',
    );
  }
}
