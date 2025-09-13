import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageUtils {
  // List of fallback images from assets
  static const List<String> fallbackImages = [
    'assets/business_logos/pop_and_spin1.png',
    'assets/business_logos/pop_and_spin2.png',
    'assets/business_logos/pop_and_spin3.png',
    'assets/pop_and_spin/pop_and_spin4.png',
    'assets/pop_and_spin/pop_and_spin5.png',
    'assets/everest_images/Everest-Funeral-DSC07610-1024x361-6.jpg',
    'assets/everest_images/Everest-Funeral-DSC07610-1024x361-9.jpg',
    'assets/backGround.jpg',
    'assets/backGround2.jpg',
    'assets/backGround3.jpg',
  ];
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static String? fixImageUrl(String? url, String? baseUrl) {
    if (url == null || url.isEmpty) return null;

    if (isValidUrl(url)) {
      return url;
    }

    if (url.startsWith('/') && baseUrl != null && baseUrl.isNotEmpty) {
      return '$baseUrl$url';
    }

    return null;
  }

  static Widget buildCachedImage({
    required String? imageUrl,
    String? baseUrl,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    double? width,
    double? height,
  }) {
    final fixedUrl = fixImageUrl(imageUrl, baseUrl);

    if (fixedUrl == null || !isValidUrl(fixedUrl)) {
      return errorWidget ?? _defaultErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: fixedUrl,
      fit: fit,
      width: width,
      height: height ?? 130,
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _defaultErrorWidget(),
    );
  }

  static Widget buildAdaptiveImageContainer({
    required String? imageUrl,
    String? baseUrl,
    BoxFit fit = BoxFit.cover,
    double? width,
    double successHeight = 130,
    double errorHeight = 0,
  }) {
    final fixedUrl = fixImageUrl(imageUrl, baseUrl);

    if (fixedUrl == null || !isValidUrl(fixedUrl)) {
      return Container(
        height: errorHeight,
        width: width,
        child: errorHeight > 0 ? _defaultErrorWidget() : SizedBox.shrink(),
      );
    }

    return CachedNetworkImage(
      imageUrl: fixedUrl,
      fit: fit,
      width: width,
      placeholder: (context, url) => Container(
        height: successHeight,
        width: width,
        child: _defaultPlaceholder(),
      ),
      errorWidget: (context, url, error) => Container(
        height: errorHeight,
        width: width,
        child: errorHeight > 0 ? _defaultErrorWidget() : SizedBox.shrink(),
      ),
    );
  }

  static Widget _defaultPlaceholder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget _defaultErrorWidget() {
    return Container(
      width: 0,
      height: 0,
    );
  }

  static Widget buildFallbackCarousel({
    double height = 200,
    bool autoPlay = true,
    Duration autoPlayInterval = const Duration(seconds: 5),
  }) {
    return Container(
      height: height,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          autoPlay: autoPlay,
          autoPlayInterval: autoPlayInterval,
          enlargeCenterPage: false,
          viewportFraction: 1.0,
          aspectRatio: 16/9,
          initialPage: 0,
        ),
        items: fallbackImages.map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  static Widget buildNetworkImageWithFallback({
    required List<String> imageUrls,
    String? baseUrl,
    double height = 200,
    bool showFallbackWhenAllFail = true,
  }) {
    // Filter out invalid URLs
    List<String> validUrls = imageUrls
        .map((url) => fixImageUrl(url, baseUrl))
        .where((url) => url != null && isValidUrl(url))
        .cast<String>()
        .toList();

    if (validUrls.isEmpty && showFallbackWhenAllFail) {
      return buildFallbackCarousel(height: height);
    }

    if (validUrls.isEmpty) {
      return Container(height: 0, width: 0);
    }

    return Container(
      height: height,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 6),
          enlargeCenterPage: false,
          viewportFraction: 1.0,
          aspectRatio: 16/9,
          initialPage: 0,
        ),
        items: validUrls.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) {
                    // If this is the last valid URL and it fails, show fallback
                    if (showFallbackWhenAllFail && validUrls.length == 1) {
                      return buildFallbackCarousel(height: height);
                    }
                    return Container(height: 0, width: 0);
                  },
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
