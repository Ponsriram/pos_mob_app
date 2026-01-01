/// Model class for a restaurant report
class ReportModel {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  final String category;

  const ReportModel({
    required this.id,
    required this.title,
    required this.description,
    this.isFavorite = false,
    required this.category,
  });

  ReportModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
    String? category,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }

  static List<ReportModel> getDefaultReports() {
    return [
      const ReportModel(
        id: 'all_restaurant_sales',
        title: 'All Restaurant Sales Report',
        description: 'Total sales of all your restaurant',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'outlet_item_wise_row',
        title: 'Outlet-Item Wise Report (Row)',
        description:
            'Consolidated Summary of Item sales with outlets in row format',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'invoice_report',
        title: 'Invoice Report: All Restaurants',
        description: 'Total invoice of all your restaurants',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'pax_sales_biller',
        title: 'Pax Sales Report: Biller Wise',
        description: 'Sales per pax made by each biller',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'order_sub_order',
        title: 'Order Report: Sub-Order Wise',
        description: 'Proper bifurcation of orders based on its sub-order type',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'all_restaurant_day_wise',
        title: 'All Restaurant Report: Day Wise',
        description: 'Total sales of all your restaurant per day',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'outlet_item_wise_column',
        title: 'Outlet-Item Wise Report (Column)',
        description:
            'Consolidated Summary of Item sales with outlets in column format',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'order_summary_corporate',
        title: 'Order Summary: Corporate Customers',
        description: 'Order summary of all corporate customers with their GST',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'cancel_order_report',
        title: 'Cancel Order Report: All Restaurants',
        description:
            'Quantity and Cost of Canceled Orders from all your restaurants',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'discount_report',
        title: 'Discount Report',
        description:
            'Get a complete list of discounts on your online and offline orders',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'hourly_item_wise',
        title: 'All Restaurants Sales: Hourly Item Wise',
        description: 'Total hourly sales at your restaurant',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'category_wise',
        title: 'Category Wise Report: All Restaurants',
        description: 'Total sales from each category in your restaurant',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'orders_master',
        title: 'Orders Master Report: All Restaurants',
        description:
            'All restaurants orders with customer information & charges incurred on each bill',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'order_item_wise',
        title: 'Order Report: Item Wise All Restaurants',
        description:
            'All restaurants item wise orders with customer information & charges',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'cancel_order_item_wise',
        title: 'Cancel Order Report: Item Wise All Restaurants',
        description:
            'A summary of all your item wise orders with customer information and charges incurred on each cancelled bill',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'locality_wise',
        title: 'Locality Wise Report: All Restaurants',
        description: 'Total orders of all restaurants grouped by locality',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'item_invoice_details',
        title: 'Item Report: Invoice Details',
        description: 'Total items sold under each group in your restaurant',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'item_wise_report',
        title: 'Item Wise Report: All Restaurants',
        description: 'Total sales from each item in your restaurant',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'item_wise_brand',
        title: 'Item Wise Report (Brand Wise): All Restaurants',
        description: 'Total sales from each item in your restaurant',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'online_order_report',
        title: 'Online Order Report: All Restaurants',
        description:
            'Track online order details and activities from all restaurants',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'discounted_orders',
        title: 'Discounted Orders: All Restaurants (With Reason)',
        description:
            'All the orders with applied discounts along with the reason',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'tag_wise',
        title: 'Tag Wise Report: All Restaurants',
        description: 'Total sales from each tag in your restaurant',
        category: 'All Restaurant Report',
      ),
      const ReportModel(
        id: 'advance_order_summary',
        title: 'Advance Order Summary Report',
        description:
            'All restaurants advance orders with customer information & charges incurred on each bill',
        category: 'All Restaurant Report',
      ),
    ];
  }
}
