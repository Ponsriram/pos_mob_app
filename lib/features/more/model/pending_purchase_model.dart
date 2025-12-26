/// Model representing a pending purchase item
class PendingPurchaseModel {
  final String id;
  final String restaurantName;
  final String itemName;
  final double quantity;
  final String unit;
  final double amount;
  final DateTime date;
  final String status;
  final String type; // 'sales' or 'transfer'

  const PendingPurchaseModel({
    required this.id,
    required this.restaurantName,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.amount,
    required this.date,
    required this.status,
    required this.type,
  });

  factory PendingPurchaseModel.fromJson(Map<String, dynamic> json) {
    return PendingPurchaseModel(
      id: json['id'] as String,
      restaurantName: json['restaurant_name'] as String,
      itemName: json['item_name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_name': restaurantName,
      'item_name': itemName,
      'quantity': quantity,
      'unit': unit,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'type': type,
    };
  }
}

/// Model for filter state
class PendingPurchaseFilterModel {
  final String selectedRestaurant;
  final DateTime startDate;
  final DateTime endDate;

  const PendingPurchaseFilterModel({
    required this.selectedRestaurant,
    required this.startDate,
    required this.endDate,
  });

  PendingPurchaseFilterModel copyWith({
    String? selectedRestaurant,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PendingPurchaseFilterModel(
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
