import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/models/product_model.dart';
import 'package:pelviease_website/const/theme.dart';

class ProductImageCarousel extends StatefulWidget {
  final Product product;
  final bool isEven;
  final Color lightViolet2;
  final Color backgroundColor;

  const ProductImageCarousel({
    super.key,
    required this.product,
    required this.isEven,
    required this.lightViolet2,
    required this.backgroundColor,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.product.images.length;
    });
  }

  void _prevImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.product.images.length) %
          widget.product.images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.product.images.isNotEmpty
        ? widget.product.images[_currentIndex]
        : 'https://via.placeholder.com/150';

    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: widget.isEven ? widget.backgroundColor : widget.lightViolet2,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 240,
              width: 240,
            ),
          ),
          if (widget.product.images.length > 1) ...[
            Positioned(
              left: 16,
              child: InkWell(
                onTap: _prevImage,
                child: CircleAvatar(
                  backgroundColor: buttonColor.withOpacity(0.6),
                  child: Center(
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              child: InkWell(
                onTap: _nextImage,
                child: CircleAvatar(
                  backgroundColor: buttonColor.withOpacity(0.6),
                  child: Center(
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
