import 'package:flutter/material.dart';

/// A utility class for providing placeholder images for products
class PlaceholderImage {
  /// Returns a widget that displays a colored container with the first letter of the product name
  /// This is used when network images fail to load
  static Widget buildPlaceholder({
    required String productName,
    required int productId,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    // Create a color based on the product ID
    final color = Colors.primaries[productId % Colors.primaries.length];

    // Get the first letter of the product name
    final firstLetter =
        productName.isNotEmpty ? productName[0].toUpperCase() : '?';

    return Container(
      width: width,
      height: height,
      color: color.withOpacity(0.7),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Colors.white,
            fontSize: height != null ? height * 0.4 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Returns a network image URL for a product
  /// If the URL is not valid, it returns a fallback URL
  static String getImageUrl(String originalUrl, int productId) {
    // If the URL is valid, use it
    if (originalUrl.startsWith('http') &&
        (originalUrl.contains('picsum.photos'))) {
      return originalUrl;
    }

    // Otherwise, use a fallback URL with the product ID as seed
    return 'https://source.unsplash.com/300x300/?product&sig=$productId';
  }
}
