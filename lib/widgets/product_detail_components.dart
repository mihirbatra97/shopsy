import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/cart_view_model.dart';
import '../viewmodels/product_view_model.dart';
import '../models/product_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_theme.dart';
import 'ui_components.dart';
import '../widgets/quantity_controls.dart';
import '../widgets/delayed_image.dart';

/// Contains reusable components specifically for the product detail screen
/// Helper methods for product detail screen
class ProductDetailComponents {
  /// Builds the product image section with shimmer loading effect
  static Widget buildProductImage({
    required String imageUrl,
    required int productId,
    required ImageLoadingBuilder loadingBuilder,
    required ImageErrorWidgetBuilder errorBuilder,
  }) {
    // Use a default product name since we can't await here
    const String productName = 'Product';
    
    return Hero(
      tag: 'product-$productId',
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DelayedImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
              productId: productId,
              productName: productName,
              minLoadingDuration: const Duration(milliseconds: 0),
              loadingBuilder: (context, _) => UIComponents.buildShimmerEffect(300),
              errorBuilder: (context, error, stackTrace) => UIComponents.buildImageErrorWidget(),
            ),
            // Gradient overlay for better text visibility
            UIComponents.buildGradientOverlay(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
              height: 120,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the product badges (sale, trending, etc.)
  static Widget buildProductBadges({
    required bool isOnSale,
    required bool isTrending,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (isOnSale)
            UIComponents.buildBadge(
              text: 'SALE',
              color: AppTheme.secondaryColor,
              fontSize: 12,
            ),
          if (isOnSale && isTrending) const SizedBox(width: 8),
          if (isTrending)
            UIComponents.buildBadge(
              text: 'TRENDING',
              color: AppTheme.accentColor,
              icon: const Icon(Icons.trending_up, color: Colors.white, size: 12),
              fontSize: 12,
            ),
        ],
      ),
    );
  }

  /// Builds the rating section with stars
  static Widget buildRatingSection({
    required double rating,
    required int reviewCount,
  }) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            size: 18,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$rating',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewCount reviews)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Builds the delivery information section
  static Widget buildDeliveryInfo({
    required bool isFreeDelivery,
    required String deliveryDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                isFreeDelivery ? 'Free Delivery' : 'Standard Delivery',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isFreeDelivery) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                'Estimated delivery by $deliveryDate',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a grid of product specifications
  static Widget buildSpecificationsGrid({
    required Map<String, String> specifications,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: specifications.length,
      itemBuilder: (context, index) {
        final entry = specifications.entries.elementAt(index);
        return UIComponents.buildSpecItem(entry.key, entry.value);
      },
    );
  }

  /// Builds the price section with original and sale prices
  static Widget buildPriceSection({
    required double price,
    required bool isOnSale,
    double? originalPrice,
    double discountPercentage = 0,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\u20b9${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        if (isOnSale && originalPrice != null) ...[          const SizedBox(width: 8),
          Text(
            '\u20b9${originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '-${discountPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: AppTheme.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  /// Builds a specification item for the product details
  static Widget buildSpecificationItem(String title, String value) {
    return UIComponents.buildSpecItem(title, value);
  }

  /// Builds the app bar for product detail screen with cart button
  static PreferredSizeWidget buildAppBar(String title, CartViewModel cartViewModel) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, shadows: [
          Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 3)
        ]),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [buildCartButton(cartViewModel)],
    );
  }

  /// Builds the cart button with badge showing item count
  static Widget buildCartButton(CartViewModel cartViewModel) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black87),
          onPressed: () => Get.toNamed(AppRoutes.cart),
        ),
        cartViewModel.cartItems.isNotEmpty
            ? Positioned(
                top: 5,
                right: 5,
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        '${cartViewModel.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  /// Helper method to get month name from month number
  static String getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  /// Builds the bottom action bar with add to cart button
  static Widget buildBottomActionBar({
    required CartViewModel cartViewModel,
    required int productId,
    required String productName,
    required double price,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity controls
          Obx(() {
            final int quantity = _getItemQuantity(cartViewModel, productId);
            return QuantityControls(
              quantity: quantity,
              onIncrease: () => cartViewModel.increaseQuantity(productId),
              onDecrease: () => cartViewModel.decreaseQuantity(productId),
              onRemove: () => cartViewModel.removeFromCart(productId),
              compact: false,
            );
          }),
          const SizedBox(width: 16),
          // Add to cart button
          Expanded(
            child: Obx(() {
              final bool isInCart = _isProductInCart(cartViewModel, productId);
              return ElevatedButton.icon(
                onPressed: () async {
                  if (!isInCart) {
                    // Since we already have all product info, just create a new Product directly
                    final product = Product(
                      id: productId,
                      name: productName,
                      price: price,
                      imageUrl: imageUrl,
                      description: '', // These fields aren't used for cart display
                      category: '',
                    );
                    cartViewModel.addToCart(product);
                  } else {
                    Get.toNamed(AppRoutes.cart);
                  }
                },
                icon: Icon(isInCart ? Icons.shopping_cart : Icons.add_shopping_cart),
                label: Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  
  /// Helper method to check if a product is in the cart
  static bool _isProductInCart(CartViewModel cartViewModel, int productId) {
    return cartViewModel.cartItems.any((item) => item.product.id == productId);
  }
  
  /// Helper method to get the quantity of an item in the cart
  static int _getItemQuantity(CartViewModel cartViewModel, int productId) {
    final index = cartViewModel.cartItems.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? cartViewModel.cartItems[index].quantity : 0;
  }
  
  /// Helper method to find a product by ID
  static Future<Product?> _findProductById(int productId) async {
    final productViewModel = Get.find<ProductViewModel>();
    return await productViewModel.findProductById(productId);
  }
}
