import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_detail_components.dart';
import '../widgets/ui_components.dart';

/// Class to hold product attributes for display purposes
class ProductAttributes {
  final double rating;
  final int reviewCount;
  final bool isOnSale;
  final bool hasFreeDelivery;
  final bool isTrending;
  final String deliveryDate;
  final Map<String, String> specifications;

  ProductAttributes({
    required this.rating,
    required this.reviewCount,
    required this.isOnSale,
    required this.hasFreeDelivery,
    required this.isTrending,
    required this.deliveryDate,
    required this.specifications,
  });
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();
    final int productId = Get.arguments as int;
    final product = productController.findProductById(productId);

    // Generate product attributes for demo purposes
    final ProductAttributes attributes = _generateProductAttributes(product.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ProductDetailComponents.buildAppBar(product.name, cartController),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                bottom: 80), // Extra padding for bottom button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with Hero animation
                Stack(
                  children: [
                    // Image
                    ProductDetailComponents.buildProductImage(
                      imageUrl: product.imageUrl,
                      productId: product.id,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return UIComponents.buildShimmerEffect(300);
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          UIComponents.buildImageErrorWidget(),
                    ),

                    // Gradient overlay for better text visibility
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Product badges (Sale, Trending, etc.)
                    ProductDetailComponents.buildProductBadges(
                      isOnSale: attributes.isOnSale,
                      isTrending: attributes.isTrending,
                    ),
                  ],
                ),

                // Product info container
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name with larger font
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Category
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rating stars
                        ProductDetailComponents.buildRatingSection(
                          rating: attributes.rating,
                          reviewCount: attributes.reviewCount,
                        ),
                        const SizedBox(height: 24),

                        // Price section with sale price if applicable
                        ProductDetailComponents.buildPriceSection(
                          price: product.price,
                          isOnSale: attributes.isOnSale,
                          originalPrice:
                              attributes.isOnSale ? product.price * 1.2 : null,
                          discountPercentage: 20,
                        ),
                        const SizedBox(height: 24),

                        // Description with enhanced styling
                        UIComponents.buildSectionHeader('Description'),
                        const SizedBox(height: 12),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Divider for visual separation
                        const Divider(height: 1),
                        const SizedBox(height: 24),

                        // Delivery info with enhanced styling
                        UIComponents.buildSectionHeader('Delivery Information'),
                        const SizedBox(height: 16),
                        ProductDetailComponents.buildDeliveryInfo(
                          isFreeDelivery: attributes.hasFreeDelivery,
                          deliveryDate: attributes.deliveryDate,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating bottom bar with add to cart button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProductDetailComponents.buildBottomActionBar(
              cartController: cartController,
              productId: product.id,
              productName: product.name,
              price: product.price,
              imageUrl: product.imageUrl,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to get month name from month number
  String _getMonth(int month) {
    return ProductDetailComponents.getMonth(month);
  }

  /// Generates product attributes for display purposes
  ProductAttributes _generateProductAttributes(int productId) {
    final double rating = ((productId % 20) + 80) / 20; // 4.0-4.95
    final int reviewCount = (productId * 7) % 500 + 50; // 50-549
    final bool isOnSale = productId % 5 == 0;
    final bool hasFreeDelivery = productId % 2 == 0;
    final bool isTrending = productId % 3 == 0;

    final DateTime deliveryDate = DateTime.now().add(const Duration(days: 3));
    final String formattedDeliveryDate =
        '${deliveryDate.day} ${_getMonth(deliveryDate.month)}';

    return ProductAttributes(
      rating: rating,
      reviewCount: reviewCount,
      isOnSale: isOnSale,
      hasFreeDelivery: hasFreeDelivery,
      isTrending: isTrending,
      deliveryDate: formattedDeliveryDate,
      specifications: {
        'Brand': 'Shopsy',
        'Category': 'Premium',
        'SKU': 'SHP$productId',
        'In Stock': 'Yes',
      },
    );
  }

  // App bar has been moved to ProductDetailComponents class

  /// Builds a specification item for the product details
  Widget _buildSpecificationItem(String title, String value) {
    return ProductDetailComponents.buildSpecificationItem(title, value);
  }

  // Cart button has been moved to ProductDetailComponents class
}
