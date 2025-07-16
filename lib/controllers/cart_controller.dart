import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  
  @override
  void onInit() {
    loadCartFromStorage();
    super.onInit();
  }

  double get totalPrice => cartItems.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity));

  int get itemCount => cartItems.fold(
      0, (sum, item) => sum + item.quantity);

  void addToCart(Product product) {
    final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id);
    
    if (existingItemIndex >= 0) {
      // Product already in cart, increase quantity
      cartItems[existingItemIndex].quantity++;
    } else {
      // Add new product to cart
      cartItems.add(CartItem(product: product));
    }
    
    saveCartToStorage();
    Get.snackbar(
      'Item Added',
      '${product.name} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void removeFromCart(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final product = cartItems[index].product;
      cartItems.removeAt(index);
      saveCartToStorage();
      
      Get.snackbar(
        'Item Removed',
        '${product.name} has been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void decreaseQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        print('Decreased quantity for product $productId to ${cartItems[index].quantity}');
      } else {
        print('Removing product $productId from cart (quantity was 1)');
        removeFromCart(productId);
      }
      saveCartToStorage();
    } else {
      print('Product $productId not found in cart for decreasing');
    }
  }

  void increaseQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      cartItems[index].quantity++;
      saveCartToStorage();
      print('Increased quantity for product $productId to ${cartItems[index].quantity}');
    } else {
      print('Product $productId not found in cart');
    }
  }

  void clearCart() {
    cartItems.clear();
    saveCartToStorage();
  }

  // Save cart to local storage
  Future<void> saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = cartItems.map((item) => item.toJson()).toList();
      await prefs.setString('cart', jsonEncode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Load cart from local storage
  Future<void> loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('cart');
      
      if (cartString != null && cartString.isNotEmpty) {
        final List<dynamic> cartData = jsonDecode(cartString);
        cartItems.value = cartData
            .map((item) => CartItem.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }
}
