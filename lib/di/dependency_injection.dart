import 'package:get/get.dart';
import '../repositories/product_repository.dart';
import '../repositories/cart_repository.dart';
import '../viewmodels/product_view_model.dart';
import '../viewmodels/cart_view_model.dart';

/// Class responsible for initializing and managing dependencies
class DependencyInjection {
  /// Initialize all dependencies needed for the app
  static void init() {
    // Repositories
    Get.lazyPut<ProductRepository>(() => ProductRepository(), fenix: true);
    Get.lazyPut<CartRepository>(() => CartRepository(), fenix: true);
    
    // ViewModels
    Get.lazyPut<ProductViewModel>(
      () => ProductViewModel(Get.find<ProductRepository>()), 
      fenix: true
    );
    
    Get.lazyPut<CartViewModel>(
      () => CartViewModel(Get.find<CartRepository>()), 
      fenix: true
    );
  }
}
