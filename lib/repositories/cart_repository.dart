import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

/// Repository responsible for cart data operations and persistence
class CartRepository {
  static const String _cartKey = 'cart';

  /// Saves cart items to local storage
  Future<void> saveCart(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = items.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
      throw Exception('Failed to save cart');
    }
  }

  /// Loads cart items from local storage
  Future<List<CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);
      
      if (cartString != null && cartString.isNotEmpty) {
        final List<dynamic> cartData = jsonDecode(cartString);
        return cartData
            .map((item) => CartItem.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error loading cart: $e');
      throw Exception('Failed to load cart');
    }
  }

  /// Adds a product to cart or increases quantity if already present
  Future<void> addToCart(List<CartItem> currentItems, Product product) async {
    final existingItemIndex = currentItems.indexWhere(
        (item) => item.product.id == product.id);
    
    final newItems = List<CartItem>.from(currentItems);
    
    if (existingItemIndex >= 0) {
      // Increase quantity of existing item
      newItems[existingItemIndex].quantity++;
    } else {
      // Add new item
      newItems.add(CartItem(product: product));
    }
    
    await saveCart(newItems);
  }

  /// Removes a product from cart
  Future<void> removeFromCart(List<CartItem> currentItems, int productId) async {
    final index = currentItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newItems = List<CartItem>.from(currentItems);
      newItems.removeAt(index);
      await saveCart(newItems);
    }
  }

  /// Decreases quantity of a product in cart
  Future<void> decreaseQuantity(List<CartItem> currentItems, int productId) async {
    final index = currentItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newItems = List<CartItem>.from(currentItems);
      if (newItems[index].quantity > 1) {
        newItems[index].quantity--;
        await saveCart(newItems);
      } else {
        await removeFromCart(currentItems, productId);
      }
    }
  }

  /// Increases quantity of a product in cart
  Future<void> increaseQuantity(List<CartItem> currentItems, int productId) async {
    final index = currentItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newItems = List<CartItem>.from(currentItems);
      newItems[index].quantity++;
      await saveCart(newItems);
    }
  }

  /// Clears all items from cart
  Future<void> clearCart() async {
    await saveCart([]);
  }
}
