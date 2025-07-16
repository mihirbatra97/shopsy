import 'package:get/get.dart';
import '../views/product_list_screen.dart';
import '../views/product_detail_screen.dart';
import '../views/cart_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';

  static final routes = [
    GetPage(
      name: home,
      page: () => const ProductListScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: productDetail,
      page: () => const ProductDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: cart,
      page: () => const CartScreen(),
      transition: Transition.downToUp,
    ),
  ];
}
