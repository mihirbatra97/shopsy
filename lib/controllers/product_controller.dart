import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      final String response = await rootBundle.loadString('assets/products.json');
      final List<dynamic> data = json.decode(response);
      productList.value = data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Product findProductById(int id) {
    return productList.firstWhere((product) => product.id == id);
  }
}
