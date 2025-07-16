import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../repositories/cart_repository.dart';

/// ViewModel for cart-related operations and UI state
class CartViewModel extends GetxController {
  final CartRepository _repository;
  
  // Observable states
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = true.obs;
  
  CartViewModel(this._repository);
  
  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage();
  }
  
  /// Computed property for total price of all items in cart
  double get totalPrice => cartItems.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity));
  
  /// Computed property for total number of items in cart
  int get itemCount => cartItems.fold(
      0, (sum, item) => sum + item.quantity);
  
  /// Load cart items from local storage via repository
  Future<void> loadCartFromStorage() async {
    try {
      isLoading(true);
      final items = await _repository.loadCart();
      cartItems.value = items;
    } catch (e) {
      debugPrint('Error loading cart: $e');
      Get.snackbar(
        'Error',
        'Failed to load your cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
  
  /// Add a product to cart or increase its quantity if already present
  Future<void> addToCart(Product product) async {
    try {
      await _repository.addToCart(cartItems, product);
      // Update observable list after repository operation
      await loadCartFromStorage();
      
      // Show success message
      Get.snackbar(
        'Item Added',
        '${product.name} has been added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Remove a product from cart by its ID
  Future<void> removeFromCart(int productId) async {
    try {
      // Store product name before removal for the success message
      final product = cartItems.firstWhere((item) => item.product.id == productId).product;
      
      await _repository.removeFromCart(cartItems, productId);
      // Update observable list after repository operation
      await loadCartFromStorage();
      
      // Show success message
      Get.snackbar(
        'Item Removed',
        '${product.name} has been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Decrease quantity of a product in cart
  Future<void> decreaseQuantity(int productId) async {
    try {
      await _repository.decreaseQuantity(cartItems, productId);
      // Update observable list after repository operation
      await loadCartFromStorage();
    } catch (e) {
      debugPrint('Error decreasing quantity: $e');
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Increase quantity of a product in cart
  Future<void> increaseQuantity(int productId) async {
    try {
      await _repository.increaseQuantity(cartItems, productId);
      // Update observable list after repository operation
      await loadCartFromStorage();
    } catch (e) {
      debugPrint('Error increasing quantity: $e');
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Clear all items from cart
  Future<void> clearCart() async {
    try {
      await _repository.clearCart();
      cartItems.clear();
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
