/// Stub model for sales report summary row data
class SalesReportSummaryData {
  final int total;
  final double totalDiscount;
  final double netSales;
  final double totalTax;
  final double totalSales;
  final double cash;
  final double card;
  final double online;

  const SalesReportSummaryData({
    this.total = 0,
    this.totalDiscount = 0,
    this.netSales = 0,
    this.totalTax = 0,
    this.totalSales = 0,
    this.cash = 0,
    this.card = 0,
    this.online = 0,
  });
}

/// Stub model for a single store sales report row
class SalesReportData {
  final String storeName;
  final int totalBills;
  final double totalDiscount;
  final double netSales;
  final double totalTax;
  final double totalSales;
  final double cash;
  final double card;
  final double online;

  const SalesReportData({
    required this.storeName,
    this.totalBills = 0,
    this.totalDiscount = 0,
    this.netSales = 0,
    this.totalTax = 0,
    this.totalSales = 0,
    this.cash = 0,
    this.card = 0,
    this.online = 0,
  });
}

/// Stub model for a report column configuration
class ReportColumn {
  final String id;
  final String displayName;
  final bool isVisible;

  const ReportColumn({
    required this.id,
    required this.displayName,
    this.isVisible = true,
  });
}
