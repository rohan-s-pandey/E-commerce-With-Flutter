import 'package:ecommerce_app/cart_item.dart';

class Order {
  final String id; // Unique identifier for the order
  final double totalAmount; // Total amount of the order
  final String address; // Shipping address for the order
  final String paymentMethod; // Payment method used for the order
  final DateTime date; // Date when the order was placed
  final List<CartItem> items; // List of items in the order

  Order({
    required this.id,
    required this.totalAmount,
    required this.address,
    required this.paymentMethod,
    required this.date,
    required this.items,
  });

  // Convert an Order into a map for JSON encoding
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'address': address,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String(), // Convert date to string format for JSON
      'items': items
          .map((item) => item.toMap())
          .toList(), // Map items to JSON-compatible format
    };
  }

  // Create an Order from a map for JSON decoding
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      totalAmount: map['totalAmount'],
      address: map['address'],
      paymentMethod: map['paymentMethod'],
      date: DateTime.parse(map['date']), // Parse string date back to DateTime
      items: (map['items'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
