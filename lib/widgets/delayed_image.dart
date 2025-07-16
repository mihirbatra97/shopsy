import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/placeholder_image.dart';

/// A widget that guarantees showing shimmer for at least 200ms before displaying the image
class DelayedImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final Duration minLoadingDuration;
  final Widget Function(BuildContext, Widget?) loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?) errorBuilder;
  final int productId; // Added product ID for placeholder generation
  final String productName; // Added product name for placeholder generation

  const DelayedImage({
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.fit,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.productId,
    required this.productName,
    this.minLoadingDuration =
        const Duration(milliseconds: 200), // Default to 200ms
  });

  @override
  State<DelayedImage> createState() => _DelayedImageState();
}

class _DelayedImageState extends State<DelayedImage> {
  bool _showImage = false;
  bool _imageLoaded = false;
  bool _hasError = false;
  Timer? _minLoadingTimer;

  @override
  void initState() {
    super.initState();
    // Always show shimmer for at least the minimum duration
    _minLoadingTimer = Timer(widget.minLoadingDuration, () {
      if (mounted && _imageLoaded) {
        setState(() {
          _showImage = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-load the image after dependencies are available
    _loadImage();
  }

  void _loadImage() {
    // Create image provider
    final imageProvider = NetworkImage(widget.imageUrl);

    // Load the image
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener(
      (info, synchronousCall) {
        if (mounted) {
          setState(() {
            _imageLoaded = true;
            if (_minLoadingTimer?.isActive == false) {
              _showImage = true;
            }
          });
        }
      },
      onError: (error, stackTrace) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      },
    );

    stream.addListener(listener);
  }

  @override
  void dispose() {
    _minLoadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error state if there was an error loading the image
    if (_hasError) {
      // Use the placeholder image instead of the default error builder
      return PlaceholderImage.buildPlaceholder(
        productName: widget.productName,
        productId: widget.productId,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    // Show shimmer while loading or during minimum duration
    if (!_showImage || !_imageLoaded) {
      return widget.loadingBuilder(context, null);
    }

    // Show the actual image once loaded and minimum duration passed
    return Image.network(
      // Use the placeholder image utility to get a reliable image URL
      PlaceholderImage.getImageUrl(widget.imageUrl, widget.productId),
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      // No need for loading builder as we handle that separately
      errorBuilder: (context, error, stackTrace) =>
          PlaceholderImage.buildPlaceholder(
        productName: widget.productName,
        productId: widget.productId,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      ),
    );
  }
}
