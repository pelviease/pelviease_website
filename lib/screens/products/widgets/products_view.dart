import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/models/product_model.dart';
import 'package:pelviease_website/const/theme.dart';

import 'imgaes_carousel.dart';

class ProductsView extends StatelessWidget {
  final Product product;
  final bool isEven;

  const ProductsView({super.key, required this.product, this.isEven = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isEven ? lightViolet2 : backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image Section
          isEven ? imageSection() : detailsSection(),

          const SizedBox(width: 48),

          // Product Details Section
          isEven ? detailsSection() : imageSection(),
        ],
      ),
    );
  }

  Expanded imageSection() {
    return Expanded(
      flex: 2,
      child: ProductImageCarousel(
        product: product,
        isEven: isEven,
        lightViolet2: lightViolet2,
        backgroundColor: backgroundColor,
      ),
    );
  }

  Expanded detailsSection() {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Product Name
          SelectableText(
            product.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 2.0,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          SelectableText(
            product.description,
            maxLines: 4,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 16),

          // Rating
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < product.currentRating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: buttonColor,
                  size: 20,
                );
              }),
              const SizedBox(width: 12),
              Text(
                '${product.currentRating}/5',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                ' (${product.totalRatingCount})',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Certification
          if (product.isCertified)
            Row(
              children: [
                Icon(
                  Icons.verified,
                  color: Colors.green.shade600,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'CDSCO Certified',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Price and Buy Section
          Row(
            children: [
              // Price Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '₹ ${product.originalPrice}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade400,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${product.discountPrice}/-',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 32),

              // Buy Now Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text(
                        'Buy now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_outward_outlined,
                          color: buttonColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
