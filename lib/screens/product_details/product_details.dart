import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/models/cart_model.dart';
import 'package:pelviease_website/backend/models/product_model.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/backend/providers/product_provider.dart';

import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productId;
  const ProductDetailsScreen({super.key, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedImageIndex = 0;
  int quantity = 1;

  Product? product;
  bool isLoading = true;
  AuthProvider? authProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProductDetails();
    });
  }

  Future<void> _fetchProductDetails() async {
    try {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider?.isAuthenticated ?? false) {
        Provider.of<CartProvider>(context, listen: false).fetchCartItems();
      }

      final fetchedProduct =
          await provider.getProductById(widget.productId ?? "");

      if (mounted) {
        setState(() {
          product = fetchedProduct;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      // Handle error appropriately
      print('Error fetching product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : product == null
              ? Center(child: Text('Product not found'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    bool isTablet = constraints.maxWidth > 600;

                    if (isTablet) {
                      return _buildTabletLayout();
                    } else {
                      return _buildMobileLayout();
                    }
                  },
                ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          SizedBox(height: 20),
          _buildProductDetails(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildImageSection(),
              ),
              SizedBox(width: 40),
              Expanded(
                flex: 1,
                child: _buildProductDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Main product image
          Container(
            height: 300,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     blurRadius: 2,
              //     offset: Offset(1, 2),
              //   ),
              // ],
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(12),
                height: 240,
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: product?.images.isNotEmpty ?? false
                    ? Image.network(
                        product!.images[selectedImageIndex],
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey[400],
                      ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Thumbnail images
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left arrow
              if ((product?.images.length ?? 0) > 3)
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: selectedImageIndex > 0
                      ? () {
                          setState(() {
                            selectedImageIndex = (selectedImageIndex - 1)
                                .clamp(0, (product!.images.length - 1));
                          });
                        }
                      : null,
                ),
              ...List.generate(
                (product?.images.length ?? 0) > 3
                    ? 3
                    : (product?.images.length ?? 0),
                (i) {
                  int start = 0;
                  if ((product?.images.length ?? 0) > 3) {
                    if (selectedImageIndex >= (product!.images.length - 2)) {
                      start = product!.images.length - 3;
                    } else if (selectedImageIndex > 0) {
                      start = selectedImageIndex - 1;
                    }
                  }
                  int index = start + i;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.all(2),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedImageIndex == index
                              ? Color(0xFF5D4E75)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product?.images[index] ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Right arrow
              if ((product?.images.length ?? 0) > 3)
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 20),
                  onPressed: selectedImageIndex < (product!.images.length - 1)
                      ? () {
                          setState(() {
                            selectedImageIndex = (selectedImageIndex + 1)
                                .clamp(0, (product!.images.length - 1));
                          });
                        }
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEBE7E7),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Product title
          Text(
            product?.name ?? 'Product Name',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),

          // Rating and reviews
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  double rating = product?.currentRating ?? 0;
                  IconData icon;
                  if (index < rating.floor()) {
                    icon = Icons.star;
                  } else if (index < rating && rating - index >= 0.5) {
                    icon = Icons.star_half;
                  } else {
                    icon = Icons.star_border;
                  }
                  return Icon(
                    icon,
                    color: index < (product?.currentRating ?? 0)
                        ? Colors.amber
                        : Colors.grey[400],
                    size: 18,
                  );
                }),
              ),
              SizedBox(width: 8),
              Text(
                '${product?.currentRating ?? 0} (${product?.totalRatingCount ?? 0} reviews)',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          if (product?.isCDSCOCertified == true)
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
            )
          else
            const SizedBox.shrink(),
          if (product?.isCDSCOCertified == true) SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '₹ ${product?.basePrice}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${product?.finalPrice}/-',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Description
          Text(
            product?.description ?? 'No description available.',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.remove, color: Colors.white, size: 18),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 20),
              Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 18),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 32),

          // Action buttons
          LayoutBuilder(
            builder: (context, constraints) {
              bool isSmallScreen = constraints.maxWidth < 400;

              if (isSmallScreen) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAddToCartButton(),
                    _buildBuyNowButton(),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(child: _buildAddToCartButton()),
                    SizedBox(width: 16),
                    Expanded(child: _buildBuyNowButton()),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              if (authProvider?.isAuthenticated == false) {
                context.goNamed("authScreen");
                return;
              }

              final isInCart = cartProvider.cartItems
                  .any((item) => item.productId == product!.id);
              if (!isInCart) {
                final cartItem = CartItem(
                  productId: product!.id,
                  id: const Uuid().v4(),
                  productName: product!.name,
                  description: product!.description,
                  price: product!.finalPrice,
                  quantity: quantity,
                  image: product!.images.isNotEmpty ? product!.images[0] : '',
                );
                cartProvider.addItem(cartItem);
              } else {
                context.goNamed("cartScreen");
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[400]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              cartProvider.cartItems
                      .any((item) => item.productId == product!.id)
                  ? 'VIEW CART'
                  : 'ADD TO CART',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBuyNowButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          if (authProvider?.isAuthenticated == false) {
            context.goNamed("authScreen");
            return;
          }
          // Handle buy now action
          final cartProvider =
              Provider.of<CartProvider>(context, listen: false);
          final isInCart = cartProvider.cartItems
              .any((item) => item.productId == product!.id);
          if (!isInCart) {
            final cartItem = CartItem(
              productId: product!.id,
              id: const Uuid().v4(),
              productName: product!.name,
              description: product!.description,
              price: product!.finalPrice,
              quantity: quantity,
              image: product!.images.isNotEmpty ? product!.images[0] : '',
            );
            cartProvider.addItem(cartItem);
          }
          context.goNamed(
            "cartScreen",
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF5D4E75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'BUY NOW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
