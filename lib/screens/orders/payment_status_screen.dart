import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/backend/providers/checkout_provider.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/const/toaster.dart';
import 'package:toastification/toastification.dart';

import 'payments/payments_service.dart';
import 'payment_order_data.dart';

class PaymentStatusScreen extends StatefulWidget {
  final String? transactionId;

  const PaymentStatusScreen({super.key, required this.transactionId});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  bool _isCheckingStatus = false;
  bool _isPlacingOrder = false;
  String? _statusMessage;
  String? _paymentStatus;
  bool _orderPlaced = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
    _checkPaymentStatus();
  }

  void _checkUserLoginStatus() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _isLoggedIn = authProvider.user != null;
  }

  Future<void> _checkPaymentStatus() async {
    if (widget.transactionId == null || widget.transactionId!.isEmpty) {
      setState(() {
        _statusMessage = 'Transaction ID not found.\nPlease contact support.';
        _paymentStatus = 'ERROR';
      });
      return;
    }

    setState(() {
      _isCheckingStatus = true;
      _statusMessage = 'Checking payment status...';
    });

    try {
      final paymentService = PaymentService();
      final transactionDetails =
          await paymentService.getTransactionDetails(widget.transactionId!);

      print("Transaction Details: $transactionDetails");

      final status = transactionDetails?['status'] as String?;

      setState(() {
        _paymentStatus = status;
      });

      if (status == 'SUCCESS') {
        setState(() {
          _statusMessage = 'Payment successful! Processing your order...';
        });

        // If user is logged in, try to place order directly
        // Otherwise, just show success message for cross-device scenario
        if (_isLoggedIn && PaymentOrderData.instance.hasData) {
          await _placeOrder();
        } else {
          // User not logged in (mobile redirect scenario) - just show success
          setState(() {
            _statusMessage =
                'Payment successful!\nYour order will be processed and you will receive an email confirmation.';
          });
        }
      } else if (status == 'FAILED') {
        setState(() {
          _statusMessage = 'Payment failed. Please try again.';
        });
      } else {
        setState(() {
          _statusMessage = 'Payment is pending. Please wait...';
        });
        // Retry checking status after some delay
        await Future.delayed(Duration(seconds: 3));
        if (mounted) {
          _checkPaymentStatus();
        }
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error checking payment status: $e';
        _paymentStatus = 'ERROR';
      });
    } finally {
      setState(() {
        _isCheckingStatus = false;
      });
    }
  }

  Future<void> _placeOrder() async {
    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final orderData = PaymentOrderData.instance;

      // Check if we have stored order data
      if (!orderData.hasData) {
        setState(() {
          _statusMessage =
              'Order data not found. Please restart the order process.';
        });
        return;
      }

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final checkoutProvider =
          Provider.of<CheckoutProvider>(context, listen: false);

      // Use stored order data
      final cartItems = orderData.cartItems!;
      final userId = orderData.userId!;
      final userName = orderData.userName!;
      final phoneNumber = orderData.phoneNumber!;
      final discount = orderData.discount!;

      // Place the order
      final success = await checkoutProvider.placeOrder(
        cartItems: cartItems,
        userId: userId,
        userName: userName,
        phoneNumber: phoneNumber,
        userFcmToken: "",
        discount: discount,
      );

      if (success) {
        // Clear the cart after successful order
        await cartProvider.clearCart();

        // Clear stored order data
        orderData.clear();

        setState(() {
          _orderPlaced = true;
          _statusMessage = 'Order placed successfully!';
        });

        showCustomToast(
          title: "Order Confirmed",
          description: "Your order has been placed successfully!",
          type: ToastificationType.success,
        );
      } else {
        setState(() {
          _statusMessage = 'Failed to place order. Please contact support.';
        });

        showCustomToast(
          title: "Order Failed",
          description:
              "Failed to place order despite successful payment. Please contact support.",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error placing order: $e';
      });

      showCustomToast(
        title: "Order Failed",
        description: "Error placing order: $e",
        type: ToastificationType.error,
      );
    } finally {
      setState(() {
        _isPlacingOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transactionId == null || widget.transactionId!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Payment Status')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 100, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                "Transaction ID not found.\nPlease contact support.",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text("Go to Home"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Status'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isCheckingStatus || _isPlacingOrder)
                Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _paymentStatus == 'SUCCESS'
                            ? Colors.green
                            : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              if (_paymentStatus == 'SUCCESS' && _orderPlaced)
                Icon(Icons.check_circle, size: 100, color: Colors.green)
              else if (_paymentStatus == 'FAILED' || _paymentStatus == 'ERROR')
                Icon(Icons.cancel, size: 100, color: Colors.red)
              else if (_paymentStatus == 'SUCCESS' && !_orderPlaced)
                Icon(Icons.payment, size: 100, color: Colors.orange)
              else if (!_isCheckingStatus && !_isPlacingOrder)
                Icon(Icons.hourglass_empty, size: 100, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                _statusMessage ?? 'Processing...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Show additional info for cross-device scenario
              if (_paymentStatus == 'SUCCESS' && !_isLoggedIn)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        'Payment confirmed! You will receive an email confirmation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),
              if (!_isCheckingStatus && !_isPlacingOrder)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_paymentStatus == 'FAILED' || _paymentStatus == 'ERROR')
                      ElevatedButton(
                        onPressed: () {
                          // Clear any stored order data and go back to checkout
                          PaymentOrderData.instance.clear();
                          context.go('/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Try Again"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (_orderPlaced) {
                          PaymentOrderData.instance.clear();
                          context.go('/orders');
                        } else {
                          PaymentOrderData.instance.clear();
                          context.go('/');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _orderPlaced ? Colors.green : Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_orderPlaced ? "View Orders" : "Go to Home"),
                    ),
                  ],
                ),
              if (_paymentStatus == 'SUCCESS' &&
                  !_orderPlaced &&
                  !_isPlacingOrder)
                const SizedBox(height: 16),
              if (_paymentStatus == 'SUCCESS' &&
                  !_orderPlaced &&
                  !_isPlacingOrder)
                TextButton(
                  onPressed: _placeOrder,
                  child: Text("Retry Order Placement"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
