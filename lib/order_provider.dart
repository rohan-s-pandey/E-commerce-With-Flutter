import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    _loadOrders(); // Load orders when the provider is initialized
  }

  void addOrder(Order order) {
    _orders.add(order);
    _saveOrders(); // Save orders whenever a new one is added
    notifyListeners(); // Notify listeners of changes
  }

  void cancelOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    _saveOrders(); // Save orders whenever one is canceled
    notifyListeners(); // Notify listeners of changes
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = _orders.map((order) => order.toMap()).toList();
      prefs.setString('orders', json.encode(ordersJson)); // Save as JSON string
    } catch (error) {
      print("Error saving orders: $error");
    }
  }

  Future<void> _loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString('orders');
      if (ordersJson != null) {
        final List<dynamic> ordersList = json.decode(ordersJson);
        _orders = ordersList.map((order) => Order.fromMap(order)).toList();
        notifyListeners(); // Notify listeners of changes
      }
    } catch (error) {
      print("Error loading orders: $error");
    }
  }
}
