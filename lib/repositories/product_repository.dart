import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

/// Repository responsible for product data operations
class ProductRepository {
  /// Fetches products from the local JSON file
  Future<List<Product>> getProducts() async {
    try {
      final String response =
          await rootBundle.loadString('assets/products.json');
      final List<dynamic> data = json.decode(response);
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      // Log error and rethrow for handling in view model
      throw Exception('Failed to load products');
    }
  }

  /// Finds a product by ID by loading all products and then finding by ID
  /// Returns null if product is not found
  Future<Product?> getProductById(int id) async {
    try {
      // Load all products first, then find by ID
      final products = await getProducts();
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
