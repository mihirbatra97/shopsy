import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../routes/app_routes.dart';
import '../utils/app_theme.dart';
import 'delayed_image.dart';
import 'ui_components.dart';
import 'quantity_controls.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final CartController cartController;
  final Function(dynamic)? onTap;
  final bool showBadges;

  const ProductCard({
    Key? key, 
    required this.product, 
    required this.cartController,
    this.onTap,
    this.showBadges = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOnSale = product.id % 5 == 0;
    final bool isTrending = product.id % 3 == 0;

    return GestureDetector(
      onTap: () => onTap != null 
          ? onTap!(product) 
          : Get.toNamed(AppRoutes.productDetail, arguments: product.id),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with badges
            _buildProductImage(isOnSale, isTrending),

            // Product Info (flexible content)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Price
                    _buildPriceRow(isOnSale),

                    const Spacer(),

                    // Cart controls
                    _buildCartControls(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(bool isOnSale, bool isTrending) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'product-${product.id}',
            child: DelayedImage(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              height: 160,
              width: double.infinity,
              minLoadingDuration: const Duration(milliseconds: 0),
              loadingBuilder: (context, _) => UIComponents.buildShimmerEffect(160),
              errorBuilder: (context, error, stackTrace) => UIComponents.buildImageErrorWidget(),
            ),
          ),
          if (showBadges) _buildBadges(isOnSale, isTrending),
        ],
      ),
    );
  }

  Widget _buildBadges(bool isOnSale, bool isTrending) {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isOnSale)
              UIComponents.buildBadge(
                text: 'SALE',
                color: AppTheme.secondaryColor,
              ),
            if (isTrending)
              UIComponents.buildBadge(
                text: 'TRENDING',
                color: AppTheme.accentColor,
                icon: const Icon(Icons.trending_up, color: Colors.white, size: 10),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(bool isOnSale) {
    return Row(
      children: [
        Text(
          '\u20b9${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.primaryColor,
          ),
        ),
        if (isOnSale)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              '\u20b9${(product.price * 1.2).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.grey[600],
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCartControls() {
    return Obx(() {
      final cartItem = cartController.cartItems.firstWhereOrNull(
        (item) => item.product.id == product.id,
      );
      final isInCart = cartItem != null;

      return isInCart
          ? QuantityControls(
              quantity: cartItem.quantity,
              onIncrease: () => cartController.increaseQuantity(product.id),
              onDecrease: () => cartController.decreaseQuantity(product.id),
              onRemove: () => cartController.removeFromCart(product.id),
              compact: true,
            )
          : _buildAddToCartButton();
    });
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          // Add with animation
          cartController.addToCart(product);

          // Show a nice snackbar
          Get.snackbar(
            'Added to Cart',
            '${product.name} has been added to your cart',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.white,
            colorText: AppTheme.primaryColor,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            icon: const Icon(Icons.shopping_cart, color: AppTheme.primaryColor),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_shopping_cart, size: 16),
            SizedBox(width: 8),
            Text(
              'Add to Cart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }


}
