import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  CartProvider() {
    _loadCartFromStorage(); // Load items when initializing
  }

  List<CartItem> get items => _items;

  Future<void> addItem(String productId, String productName, double price,
      {required int quantity}) async {
    final existingItemIndex = _items.indexWhere((item) => item.id == productId);
    if (existingItemIndex >= 0) {
      // Update the quantity of an existing item
      _items[existingItemIndex].quantity += quantity;
    } else {
      // Add a new item with the specified quantity
      _items.add(CartItem(
        id: productId,
        name: productName,
        price: price,
        quantity: quantity,
      ));
    }
    await _saveCartToStorage();
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.id == productId);
    await _saveCartToStorage();
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  void clear() async {
    _items.clear();
    await _saveCartToStorage();
    notifyListeners();
  }

  // Method to save the cart data to SharedPreferences
  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsJson =
        _items.map((item) => json.encode(item.toMap())).toList();
    await prefs.setStringList('cartItems', cartItemsJson);
  }

  // Method to load the cart data from SharedPreferences
  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartItemsJson = prefs.getStringList('cartItems');
    if (cartItemsJson != null) {
      _items = cartItemsJson
          .map((itemJson) => CartItem.fromMap(json.decode(itemJson)))
          .toList();
      notifyListeners();
    }
  }
}
