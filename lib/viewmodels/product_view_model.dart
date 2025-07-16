import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

/// ViewModel for product-related operations and UI state
class ProductViewModel extends GetxController {
  final ProductRepository _repository;
  
  // Observable states
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = true.obs;
  
  // For error handling
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;
  
  ProductViewModel(this._repository);
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
  
  /// Fetch products from repository
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');
      
      final productList = await _repository.getProducts();
      products.value = productList;
    } catch (e) {
      hasError(true);
      errorMessage('Failed to load products. Please try again.');
      debugPrint('Error in ProductViewModel: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
  
  /// Find a product by its ID, ensuring products are loaded first
  Future<Product?> findProductById(int id) async {
    // If products aren't loaded yet, load them first
    if (products.isEmpty && !isLoading.value) {
      await fetchProducts();
    }
    
    try {
      // First try to find in the current list
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      // If not found, try to get directly from repository
      try {
        final directProduct = await _repository.getProductById(id);
        return directProduct;
      } catch (e) {
        debugPrint('Product with id $id not found: ${e.toString()}');
        return null;
      }
    }
  }
  
  /// Retry loading products when there's an error
  void retryLoading() {
    fetchProducts();
  }
}
