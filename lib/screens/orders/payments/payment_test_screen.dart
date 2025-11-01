import 'package:flutter/material.dart';
import 'package:pelviease_website/screens/orders/payments/payments_service.dart';
import 'package:pelviease_website/const/razorpay_config.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class PaymentTestScreen extends StatefulWidget {
  const PaymentTestScreen({super.key});

  @override
  State<PaymentTestScreen> createState() => _PaymentTestScreenState();
}

class _PaymentTestScreenState extends State<PaymentTestScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    // Set a default test amount (₹10.00 = 1000 paise)
    _amountController.text = '1000';
  }

  Future<void> _testPayment() async {
    if (_amountController.text.isEmpty) {
      setState(() {
        _message = 'Please enter an amount';
      });
      return;
    }

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _message = 'Please enter a valid amount in paise';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final paymentService = PaymentService();

      // Initiate payment - Razorpay modal will open automatically
      final orderId = await paymentService.initiatePayment(
        amountInPaise: amount,
        userName: _nameController.text.isEmpty ? null : _nameController.text,
        userEmail: _emailController.text.isEmpty ? null : _emailController.text,
        userPhone: _phoneController.text.isEmpty ? null : _phoneController.text,
        metaInfo: {
          'test_mode': 'true',
          'description': 'Test payment from Flutter web',
        },
      );

      setState(() {
        _orderIdController.text = orderId;
        _message = '✅ Payment initiated successfully!\n'
            'Order ID: $orderId\n\n'
            'The Razorpay checkout has opened.\n'
            'Complete the payment to see the status update in Firebase.';
      });
    } catch (e) {
      setState(() {
        _message = '❌ Payment initiation failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshOrderStatus() async {
    if (_orderIdController.text.isEmpty) {
      setState(() {
        _message = 'Please enter an Order ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final paymentService = PaymentService();
      final transactionDetails = await paymentService.getTransactionDetails(
        _orderIdController.text.trim(),
      );

      if (transactionDetails == null) {
        setState(() {
          _message = '❌ Transaction not found';
        });
        return;
      }

      final status = transactionDetails['status'] as String?;
      final amount = transactionDetails['amount'] as int?;
      final createdAt = transactionDetails['createdAt'];
      final razorpayPaymentId =
          transactionDetails['razorpayPaymentId'] as String?;

      String statusText = '📊 Transaction Status\n\n';
      statusText += 'Order ID: ${_orderIdController.text}\n';
      statusText += 'Status: ${status ?? 'Unknown'}\n';
      statusText +=
          'Amount: ₹${amount != null ? (amount / 100).toStringAsFixed(2) : 'N/A'}\n';

      if (razorpayPaymentId != null) {
        statusText += 'Payment ID: $razorpayPaymentId\n';
      }

      if (createdAt != null) {
        statusText += 'Created: ${createdAt.toDate()}\n';
      }

      // Add status-specific emoji
      String emoji = '';
      if (status == 'SUCCESS') {
        emoji = '✅ ';
      } else if (status == 'FAILED') {
        emoji = '❌ ';
      } else if (status == 'PENDING') {
        emoji = '⏳ ';
      } else if (status == 'CANCELLED') {
        emoji = '🚫 ';
      }

      setState(() {
        _message = emoji + statusText;
      });
    } catch (e) {
      setState(() {
        _message = '❌ Error fetching transaction: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserOrders() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final paymentService = PaymentService();
      final transactions = await paymentService.getUserTransactions(limit: 10);

      if (transactions.isEmpty) {
        setState(() {
          _message = '📭 No transactions found';
        });
        return;
      }

      String transactionsText =
          '📋 Recent Transactions (${transactions.length})\n\n';
      for (var i = 0; i < transactions.length; i++) {
        final transaction = transactions[i];
        final status = transaction['status'] as String?;
        final amount = transaction['amount'] as int?;
        final orderId = transaction['orderId'] as String?;

        transactionsText += '${i + 1}. ${status ?? 'Unknown'} - ';
        transactionsText +=
            '₹${amount != null ? (amount / 100).toStringAsFixed(2) : 'N/A'}\n';
        transactionsText += '   ID: ${orderId ?? 'N/A'}\n\n';
      }

      setState(() {
        _message = transactionsText;
      });
    } catch (e) {
      setState(() {
        _message = '❌ Error loading transactions: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Payment Test - Authentication Required'),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Authentication Required',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You must be logged in to test payment functionality.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Currently logged in: ${authProvider.user?.name ?? 'Not logged in'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go('/authentication'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Razorpay Payment Test'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Test Razorpay Payment Integration',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // User info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✅ User Authenticated',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Logged in as: ${authProvider.user?.name ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Email: ${authProvider.user?.email ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Razorpay Configuration Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💳 Payment Gateway: Razorpay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Key ID: ${RazorpayConfig.keyId}',
                          style: const TextStyle(
                              fontSize: 12, fontFamily: 'monospace'),
                        ),
                        if (RazorpayConfig.keyId == 'YOUR_RAZORPAY_KEY_ID') ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '⚠️ Please update RazorpayConfig.keyId with your actual Razorpay Key ID',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Form
                  const Text(
                    'Payment Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount in paise (e.g., 1000 for ₹10)',
                      border: OutlineInputBorder(),
                      helperText: '1 Rupee = 100 paise',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Email (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Phone (Optional)',
                      border: OutlineInputBorder(),
                      helperText: '10-digit number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.payment),
                    label: Text(
                      _isLoading ? 'Processing...' : 'Pay with Razorpay',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _message!.contains('failed') ||
                                _message!.contains('error')
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _message!.contains('failed') ||
                                  _message!.contains('error')
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      child: Text(
                        _message!,
                        style: TextStyle(
                          color: _message!.contains('failed') ||
                                  _message!.contains('error')
                              ? Colors.red.shade800
                              : Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  // Order Management Section
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _orderIdController,
                    decoration: const InputDecoration(
                      labelText: 'Order ID',
                      border: OutlineInputBorder(),
                      helperText: 'Enter order ID to check transaction status',
                      prefixIcon: Icon(Icons.receipt_long),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _refreshOrderStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Status'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _loadUserOrders,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.list),
                          label: const Text('My Orders'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'How to Use:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '1️⃣ Configure Razorpay:\n'
                    '   • Get your Key ID from https://dashboard.razorpay.com\n'
                    '   • Update lib/const/razorpay_config.dart\n\n'
                    '2️⃣ Test Payment:\n'
                    '   • Enter amount in paise (₹1 = 100 paise)\n'
                    '   • Fill optional customer details for prefill\n'
                    '   • Click "Pay with Razorpay"\n'
                    '   • Razorpay checkout modal will open\n\n'
                    '3️⃣ Check Status:\n'
                    '   • After payment, use "Refresh Status" button\n'
                    '   • Transaction status updates automatically in Firebase\n'
                    '   • View all transactions with "My Transactions" button\n\n'
                    '4️⃣ Test Cards:\n'
                    '   • Success: 4111 1111 1111 1111\n'
                    '   • Failure: 4000 0000 0000 0002\n'
                    '   • Any future expiry & CVV\n\n'
                    '📝 All transactions are stored in Firebase "transactions" collection\n'
                    '🔍 Check browser console for detailed logs',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _orderIdController.dispose();
    super.dispose();
  }
}
