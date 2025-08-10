import 'package:flutter/material.dart';
import 'package:pelviease_website/screens/orders/payments/payments_service.dart';
import 'package:pelviease_website/const/firebase_config.dart';
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
  final TextEditingController _orderIdController = TextEditingController();
  bool _isLoading = false;
  bool _isCheckingStatus = false;
  String? _message;
  String? _statusMessage;

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
      // Initiate payment and get the order ID
      final orderId =
          await paymentService.initiatePayment(amountInPaise: amount);

      setState(() {
        _message = 'Payment initiated successfully!\n'
            'Transaction ID: $orderId\n'
            'Please complete the payment in the browser/app that opened.\n'
            'After completing payment, you can check status below.';
      });

      // Auto-fill the order ID for status checking
      _orderIdController.text = orderId;

      // Note: Don't check status immediately after initiation
      // The user needs time to complete the payment first
    } catch (e) {
      setState(() {
        _message = 'Payment failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (_orderIdController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter a transaction ID';
      });
      return;
    }

    setState(() {
      _isCheckingStatus = true;
      _statusMessage = null;
    });

    try {
      final paymentService = PaymentService();
      final paymentStatus = await paymentService.checkPaymentStatus(
          merchantOrderId: _orderIdController.text.trim());

      print("Payment Status: $paymentStatus");

      // Parse the status response
      final status = paymentStatus['status'] as String?;
      final phonePeDetails =
          paymentStatus['phonePeDetails'] as Map<String, dynamic>?;

      String statusText = 'Status: ${status ?? 'Unknown'}\n';
      if (phonePeDetails != null) {
        statusText += 'PhonePe Details:\n';
        statusText += 'Order ID: ${phonePeDetails['orderId'] ?? 'N/A'}\n';
        statusText += 'State: ${phonePeDetails['state'] ?? 'N/A'}\n';
        statusText += 'Amount: ${phonePeDetails['amount'] ?? 'N/A'}\n';
      }

      setState(() {
        _statusMessage = statusText;
      });
    } catch (e) {
      setState(() {
        _message = 'Payment failed: $e';
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
            title: Text(FirebaseConfig.isUsingEmulator
                ? 'Payment Test (Local Emulator)'
                : 'Payment Test (Production)'),
            backgroundColor:
                FirebaseConfig.isUsingEmulator ? Colors.orange : Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Test PhonePe Payment Integration',
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

                  const Text(
                    'Environment Configuration:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    FirebaseConfig.isUsingEmulator
                        ? '🔧 Using Local Firebase Functions Emulator (localhost:5002)'
                        : '🚀 Using Production Firebase Functions',
                    style: TextStyle(
                      fontSize: 14,
                      color: FirebaseConfig.isUsingEmulator
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount in paise (e.g., 1000 for ₹10)',
                      border: OutlineInputBorder(),
                      helperText: '1 Rupee = 100 paise',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _testPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('Processing...'),
                            ],
                          )
                        : const Text(
                            'Test Payment',
                            style: TextStyle(fontSize: 18),
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

                  // Payment Status Checking Section
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    'Check Payment Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'After completing payment, enter the Transaction ID to check status:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _orderIdController,
                    decoration: const InputDecoration(
                      labelText: 'Transaction ID',
                      border: OutlineInputBorder(),
                      helperText:
                          'Enter the transaction ID from payment initiation',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isCheckingStatus ? null : _checkPaymentStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isCheckingStatus
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Checking Status...'),
                            ],
                          )
                        : const Text('Check Payment Status'),
                  ),
                  if (_statusMessage != null) ...[
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _statusMessage!.contains('SUCCESS')
                            ? Colors.green.shade100
                            : _statusMessage!.contains('FAILED')
                                ? Colors.red.shade100
                                : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _statusMessage!.contains('SUCCESS')
                              ? Colors.green
                              : _statusMessage!.contains('FAILED')
                                  ? Colors.red
                                  : Colors.blue,
                        ),
                      ),
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(
                          color: _statusMessage!.contains('SUCCESS')
                              ? Colors.green.shade800
                              : _statusMessage!.contains('FAILED')
                                  ? Colors.red.shade800
                                  : Colors.blue.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Instructions:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    FirebaseConfig.isUsingEmulator
                        ? '🔧 EMULATOR MODE:\n'
                            '1. Make sure Firebase Functions emulator is running:\n'
                            '   firebase emulators:start --only functions\n\n'
                            '2. The emulator should be running on localhost:5002\n\n'
                            '3. Check the debug console for detailed logs\n\n'
                            '4. Test with different amounts to verify functionality'
                        : '🚀 PRODUCTION MODE:\n'
                            '1. Connected to live Firebase Functions\n\n'
                            '2. Real payments will be processed through PhonePe\n\n'
                            '3. Make sure you are logged in\n\n'
                            '4. Check Firebase Console for function logs if needed',
                    style: const TextStyle(fontSize: 14),
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
    _orderIdController.dispose();
    super.dispose();
  }
}
