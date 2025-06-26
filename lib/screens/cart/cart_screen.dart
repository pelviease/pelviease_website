import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/models/cart_model.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:pelviease_website/const/toaster.dart';
import 'package:pelviease_website/screens/cart/widgets/empty_cart.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      color: backgroundColor,
      child: cartProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : cartProvider.errorMessage != null
              ? Center(child: Text(cartProvider.errorMessage!))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    bool isDesktop = constraints.maxWidth > 1024;
                    bool isTablet = constraints.maxWidth > 768 &&
                        constraints.maxWidth <= 1024;

                    if (cartProvider.cartItems.isEmpty) {
                      return EmptyCartWidget(
                        onContinueShopping: () {
                          context.go('/products');
                        },
                      );
                    }

                    if (isDesktop) {
                      return _buildDesktopLayout(context, cartProvider);
                    } else if (isTablet) {
                      return _buildTabletLayout(context, cartProvider);
                    } else {
                      return _buildMobileLayout(context, cartProvider);
                    }
                  },
                ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, CartProvider cartProvider) {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildCartItemsList(cartProvider),
          ),
          SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: _buildOrderSummary(context, cartProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, CartProvider cartProvider) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _buildCartItemsList(cartProvider),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _buildOrderSummary(context, cartProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, CartProvider cartProvider) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCartItemsList(cartProvider),
                  SizedBox(height: 16),
                  _buildOrderSummary(context, cartProvider),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemsList(CartProvider cartProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            children: cartProvider.cartItems
                .map((item) => _buildMobileCartCard(item, cartProvider))
                .toList(),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade600, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text('Product',
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(
                          flex: 1,
                          child: Text('Price',
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(
                          flex: 1,
                          child: Text('Quantity',
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(
                          flex: 1,
                          child: Text('Subtotal',
                              style: TextStyle(fontWeight: FontWeight.w600))),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                ...cartProvider.cartItems
                    .map((item) => _buildDesktopCartItem(item, cartProvider)),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMobileCartCard(CartItem item, CartProvider cartProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.medical_services,
                      color: Colors.purple[300],
                      size: 36,
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹ ${item.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: Colors.red[400], size: 22),
                onPressed: () => cartProvider.removeItem(item.id),
                padding: EdgeInsets.all(8),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Qty: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onPressed: () =>
                        cartProvider.updateQuantity(item.id, item.quantity - 1),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      item.quantity.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    icon: Icons.add,
                    onPressed: () =>
                        cartProvider.updateQuantity(item.id, item.quantity + 1),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '₹ ${(item.price * item.quantity).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCartItem(CartItem item, CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.medical_services,
                        color: Colors.purple[300],
                        size: 36,
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '₹ ${item.price.toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _buildQuantityButton(
                  icon: Icons.remove,
                  onPressed: () =>
                      cartProvider.updateQuantity(item.id, item.quantity - 1),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.quantity.toString(),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                _buildQuantityButton(
                  icon: Icons.add,
                  onPressed: () =>
                      cartProvider.updateQuantity(item.id, item.quantity + 1),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '₹ ${(item.price * item.quantity).toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
              onPressed: () => cartProvider.removeItem(item.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    CartProvider cartProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade600, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 12),
            _buildSummaryRow(
                'Items', cartProvider.itemCount.toString().padLeft(2, '0')),
            SizedBox(height: 12),
            _buildSummaryRow(
                'Subtotal', '₹ ${cartProvider.subtotal.toStringAsFixed(2)}'),
            SizedBox(height: 12),
            _buildSummaryRow(
                'Shipping', '₹ ${cartProvider.shipping.toStringAsFixed(2)}'),
            SizedBox(height: 12),
            // _buildSummaryRow('Coupon Discount',
            //     '-₹ ${cartProvider.couponDiscount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹ ${cartProvider.total.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (cartProvider.cartItems.isNotEmpty) {
                    context.go('/checkout');
                  } else {
                    showCustomToast(
                        title: "Empty",
                        description:
                            "Your cart is empty, please add items to proceed.",
                        type: ToastificationType.info);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
