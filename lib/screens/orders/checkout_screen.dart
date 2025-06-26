import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/backend/providers/checkout_provider.dart';
import 'package:pelviease_website/const/enums/payment_enum.dart';
import 'widgets/add_address_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String phoneNumber;

  const CheckoutScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.phoneNumber,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Theme color getters
  Color get primaryColor => Theme.of(context).colorScheme.primary;
  Color get secondaryColor => Theme.of(context).colorScheme.secondary;
  Color get accentColor => Theme.of(context).colorScheme.secondaryContainer;
  Color get backgroundColor => Theme.of(context).colorScheme.surface;
  Color get surfaceColor => Theme.of(context).colorScheme.surface;
  Color get textPrimaryColor =>
      Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  Color get textSecondaryColor =>
      Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

  @override
  void initState() {
    super.initState();
    Provider.of<CheckoutProvider>(context, listen: false).fetchAddresses();
  }

  void showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddAddressDialog(),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddressSection(CheckoutProvider checkoutProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Delivery Address', Icons.location_on),
          const SizedBox(height: 20),
          if (checkoutProvider.addresses.isEmpty)
            _buildEmptyAddressState()
          else
            _buildAddressSelection(checkoutProvider),
        ],
      ),
    );
  }

  Widget _buildEmptyAddressState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            size: 48,
            color: textSecondaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your delivery address to continue',
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => showAddAddressDialog(context),
            icon: const Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            label: const Text('Add Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSelection(CheckoutProvider checkoutProvider) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentColor.withOpacity(0.3)),
          ),
          child: DropdownButton<DeliveryAddress>(
            isExpanded: true,
            value: checkoutProvider.selectedAddress,
            hint: Text(
              'Select Address',
              style: TextStyle(color: textSecondaryColor),
            ),
            underline: const SizedBox(),
            items: checkoutProvider.addresses
                .map((address) => DropdownMenuItem(
                      value: address,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.fullName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                          ),
                          Text(
                            '${address.addressLine1}, ${address.city}, ${address.country}',
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (address) {
              if (address != null) {
                checkoutProvider.setSelectedAddress(address);
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => showAddAddressDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add New Address'),
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: BorderSide(color: primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(CheckoutProvider checkoutProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Payment Method', Icons.payment),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: DropdownButton<PaymentType>(
              isExpanded: true,
              value: checkoutProvider.selectedPaymentType,
              underline: const SizedBox(),
              items: PaymentType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(
                              _getPaymentIcon(type),
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _getPaymentDisplayName(type),
                              style: TextStyle(color: textPrimaryColor),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (type) {
                if (type != null) {
                  checkoutProvider.setPaymentType(type);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Order Summary', Icons.shopping_cart),
          const SizedBox(height: 20),

          // Cart Items
          ...cartProvider.cartItems.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                          ),
                          Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹ ${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Subtotal', cartProvider.subtotal),
                _buildSummaryRow('Shipping', cartProvider.shipping),
                _buildSummaryRow('Discount', -cartProvider.couponDiscount),
                const Divider(height: 24),
                _buildSummaryRow('Total', cartProvider.total, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? textPrimaryColor : textSecondaryColor,
            ),
          ),
          Text(
            '${amount < 0 ? '-' : ''}₹${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? primaryColor : textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return Icons.credit_card;
      case PaymentType.debitCard:
        return Icons.payment;
      case PaymentType.bankTransfer:
        return Icons.account_balance_wallet;
      case PaymentType.cash:
        return Icons.money;
      case PaymentType.upi:
        return Icons.qr_code;
    }
  }

  String _getPaymentDisplayName(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return 'Credit Card';
      case PaymentType.debitCard:
        return 'Debit Card';
      case PaymentType.bankTransfer:
        return 'Bank Transfer';
      case PaymentType.cash:
        return 'Cash on Delivery';
      case PaymentType.upi:
        return 'UPI Payment';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final checkoutProvider = Provider.of<CheckoutProvider>(context);
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   title: const Text('Checkout'),
      //   backgroundColor: surfaceColor,
      //   elevation: 0,
      //   foregroundColor: textPrimaryColor,
      // ),
      body: checkoutProvider.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'Processing your order...',
                    style: TextStyle(color: textSecondaryColor),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMobile)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: _buildDeliveryAddressSection(
                                      checkoutProvider)),
                              const SizedBox(width: 20),
                              Expanded(
                                  flex: 1,
                                  child: _buildPaymentMethodSection(
                                      checkoutProvider)),
                            ],
                          ),
                        if (isMobile) ...[
                          _buildDeliveryAddressSection(checkoutProvider),
                          SizedBox(
                            height: 16,
                          ),
                          _buildPaymentMethodSection(checkoutProvider),
                        ],

                        const SizedBox(height: 20),
                        _buildOrderSummarySection(cartProvider),

                        // Error Message
                        if (checkoutProvider.errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red.shade600),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    checkoutProvider.errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),

                // Bottom Place Order Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: checkoutProvider.isLoading
                            ? null
                            : () async {
                                if (checkoutProvider.selectedAddress == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Please select a delivery address'),
                                      backgroundColor: Colors.orange,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                String? userId = widget.userId.trim().isNotEmpty
                                    ? widget.userId
                                    : null;
                                String? userName =
                                    widget.userName.trim().isNotEmpty
                                        ? widget.userName
                                        : null;
                                String? phoneNumber =
                                    widget.phoneNumber.trim().isNotEmpty
                                        ? widget.phoneNumber
                                        : null;

                                if (userId == null ||
                                    userName == null ||
                                    phoneNumber == null) {
                                  final authProvider =
                                      Provider.of<AuthProvider>(context,
                                          listen: false);
                                  userId ??= authProvider.user?.id ?? '';
                                  userName ??= authProvider.user?.name ?? '';
                                  phoneNumber ??=
                                      authProvider.user?.phoneNumber ?? '';
                                }

                                final success =
                                    await checkoutProvider.placeOrder(
                                  cartItems: cartProvider.cartItems,
                                  userId: userId,
                                  userName: userName,
                                  phoneNumber: phoneNumber,
                                  userFcmToken: "",
                                );

                                if (success) {
                                  await cartProvider.clearCart();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Colors.white),
                                          const SizedBox(width: 12),
                                          const Text(
                                              'Order placed successfully!'),
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                  context.go("/orders");
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart_checkout),
                            const SizedBox(width: 8),
                            Text(
                              'Place Order • ₹ ${cartProvider.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
