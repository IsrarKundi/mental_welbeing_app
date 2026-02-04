import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Helper class for handling images that can be either assets or network URLs.
///
/// This is needed because some images have been migrated to local assets
/// while others may still be network URLs.
class AppImageProvider {
  AppImageProvider._();

  /// Returns an ImageProvider that works with both asset paths and network URLs.
  ///
  /// Asset paths start with 'assets/' while network URLs start with 'http'.
  static ImageProvider getProvider(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }
    return CachedNetworkImageProvider(imageUrl);
  }

  /// Builds an Image widget that works with both asset paths and network URLs.
  static Widget buildImage(
    String imageUrl, {
    BoxFit? fit,
    double? width,
    double? height,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    Color? color,
    BlendMode? colorBlendMode,
  }) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        color: color,
        colorBlendMode: colorBlendMode,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.white.withOpacity(0.05),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.white.withOpacity(0.05),
        child: const Icon(Icons.error_outline, color: Colors.white24),
      ),
    );
  }
}
