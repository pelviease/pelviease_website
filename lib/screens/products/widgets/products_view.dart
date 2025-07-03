import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/models/cart_model.dart';
import 'package:pelviease_website/backend/models/product_model.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'imgaes_carousel.dart';

class ProductsView extends StatelessWidget {
  final Product product;
  final bool isEven;

  const ProductsView({super.key, required this.product, this.isEven = false});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return InkWell(
      onTap: () {
        context.goNamed(
          'productDetails',
          pathParameters: {'productId': product.id},
        );
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        decoration: BoxDecoration(
          color: isEven ? lightViolet2 : backgroundColor,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image section first on mobile
                  imageSection(context),
                  SizedBox(height: isMobile ? 24 : 48),
                  // Details section below image on mobile
                  detailsSection(context),
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Product Image Section
                    isEven ? imageSection(context) : detailsSection(context),

                    const SizedBox(width: 48),

                    // Product Details Section
                    isEven ? detailsSection(context) : imageSection(context),
                  ],
                ),
              ),
      ),
    );
  }

  Widget imageSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      return SizedBox(
        width: double.infinity,
        height: 250,
        child: ProductImageCarousel(
          product: product,
          isEven: isEven,
          lightViolet2: lightViolet2,
          backgroundColor: backgroundColor,
        ),
      );
    } else {
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
  }

  Widget detailsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600;

    if (isMobile) {
      return SizedBox(
        width: double.infinity,
        child: _buildDetailsContent(
          context,
          isMobile: true,
          isTablet: false,
        ),
      );
    } else {
      return Expanded(
        flex: 3,
        child: _buildDetailsContent(
          context,
          isMobile: false,
          isTablet: isTablet,
        ),
      );
    }
  }

  Widget _buildDetailsContent(BuildContext context,
      {required bool isMobile, required bool isTablet}) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Product Name
        SelectableText(
          product.name.toUpperCase(),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: isMobile ? 22 : (isTablet ? 24 : 28),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: isMobile ? 1.5 : 2.0,
          ),
        ),

        SizedBox(height: isMobile ? 8 : 12),

        // Description
        SelectableText(
          product.description,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          scrollPhysics: NeverScrollableScrollPhysics(),
          maxLines: isMobile ? 3 : 4,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: Colors.grey.shade800,
            height: 1.6,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(height: isMobile ? 12 : 16),

        // Rating
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < product.currentRating.floor()
                    ? Icons.star
                    : Icons.star_border,
                color: buttonColor,
                size: isMobile ? 18 : 20,
              );
            }),
            SizedBox(width: isMobile ? 8 : 12),
            Text(
              '${product.currentRating}/5',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              ' (${product.totalRatingCount})',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),

        SizedBox(height: isMobile ? 8 : 12),

        // Certification
        if (product.isCDSCOCertified)
          Wrap(
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(
                Icons.verified,
                color: Colors.green.shade600,
                size: isMobile ? 16 : 18,
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                'CDSCO Certified',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

        SizedBox(height: isMobile ? 12 : 16),

        // Price and Buy Section
        isMobile
            ? Column(
                children: [
                  // Price Section
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '₹ ${product.basePrice}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product.finalPrice}/-',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Buy Now Button
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        if (authProvider.isAuthenticated == false) {
                          context.goNamed("authScreen");
                          return;
                        }
                        // Handle buy now action
                        final cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        final isInCart = cartProvider.cartItems
                            .any((item) => item.productId == product.id);
                        if (!isInCart) {
                          final cartItem = CartItem(
                            productId: product.id,
                            id: const Uuid().v4(),
                            productName: product.name,
                            description: product.description,
                            price: product.finalPrice,
                            quantity: 1,
                            image: product.images.isNotEmpty
                                ? product.images[0]
                                : '',
                          );
                          cartProvider.addItem(cartItem);
                        }
                        context.goNamed(
                          "cartScreen",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Buy now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: Icon(
                              Icons.arrow_outward_outlined,
                              color: buttonColor,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: isTablet ? 16 : 32,
                runSpacing: 16,
                children: [
                  // Price Section
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '₹ ${product.basePrice}',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 18,
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product.finalPrice}/-',
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // Buy Now Button
                  SizedBox(
                    height: isTablet ? 45 : 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        if (authProvider.isAuthenticated == false) {
                          context.goNamed("authScreen");
                          return;
                        }
                        // Handle buy now action
                        final cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        final isInCart = cartProvider.cartItems
                            .any((item) => item.productId == product.id);
                        if (!isInCart) {
                          final cartItem = CartItem(
                            productId: product.id,
                            id: const Uuid().v4(),
                            productName: product.name,
                            description: product.description,
                            price: product.finalPrice,
                            quantity: 1,
                            image: product.images.isNotEmpty
                                ? product.images[0]
                                : '',
                          );
                          cartProvider.addItem(cartItem);
                        }
                        context.goNamed(
                          "cartScreen",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 24,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Buy now',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: isTablet ? 12 : 16),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: isTablet ? 14 : 16,
                            child: Icon(
                              Icons.arrow_outward_outlined,
                              color: buttonColor,
                              size: isTablet ? 18 : 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
