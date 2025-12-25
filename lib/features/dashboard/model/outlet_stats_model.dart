/// Model representing statistics for a single outlet
class OutletStatsModel {
  final String outletName;
  final bool isTotal;
  final int orders;
  final double sales;
  final double netSales;
  final double tax;
  final double discounts;
  final int modified;
  final int reprint;

  const OutletStatsModel({
    required this.outletName,
    this.isTotal = false,
    required this.orders,
    required this.sales,
    required this.netSales,
    required this.tax,
    required this.discounts,
    required this.modified,
    required this.reprint,
  });

  /// Factory constructor for creating sample outlet data
  static List<OutletStatsModel> getSampleData() {
    return const [
      OutletStatsModel(
        outletName: 'Total',
        isTotal: true,
        orders: 67,
        sales: 32266.00,
        netSales: 30742.57,
        tax: 1524.54,
        discounts: 0.00,
        modified: 0,
        reprint: 0,
      ),
      OutletStatsModel(
        outletName: 'Aarthi cake Magic',
        isTotal: false,
        orders: 0,
        sales: 0.00,
        netSales: 0.00,
        tax: 0.00,
        discounts: 0.00,
        modified: 0,
        reprint: 0,
      ),
      OutletStatsModel(
        outletName: 'Ambattur Aarthi sweets and bakery',
        isTotal: false,
        orders: 67,
        sales: 32266.00,
        netSales: 30742.57,
        tax: 1524.54,
        discounts: 0.00,
        modified: 0,
        reprint: 0,
      ),
    ];
  }
}
