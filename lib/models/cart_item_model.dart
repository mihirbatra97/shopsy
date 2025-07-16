import 'product_model.dart';
import 'package:get/get.dart';

class CartItem {
  final Product product;
  final RxInt _quantity = 1.obs;

  CartItem({
    required this.product,
    int quantity = 1,
  }) {
    _quantity.value = quantity;
  }
  
  // Getter and setter for quantity to maintain reactive state
  int get quantity => _quantity.value;
  set quantity(int value) => _quantity.value = value;

  double get totalPrice => product.price * _quantity.value;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': _quantity.value,
    };
  }
}
