import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';
import 'routes/app_routes.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize controllers
  Get.put(ProductController());
  Get.put(CartController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shopsy',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
