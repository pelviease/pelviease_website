import 'package:flutter/material.dart';
import 'package:pelviease_website/screens/orders/payments/payments_service.dart';

class PaymentTestScreen extends StatefulWidget {
  const PaymentTestScreen({super.key});

  @override
  State<PaymentTestScreen> createState() => _PaymentTestScreenState();
}

class _PaymentTestScreenState extends State<PaymentTestScreen> {
  final TextEditingController _amountController = TextEditingController();
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
      String? orderId;
      try {
        // Initiate payment and get the order ID
        orderId = await paymentService.initiatePayment(
            amountInPaise: 100); // e.g., for ₹1.00
        // Store this orderId somewhere temporarily (e.g., in your state management solution)
        // so you can use it when the user returns to the app.
      } catch (e) {
        // Show an error message to the user
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      setState(() {
        _message = 'Payment initiated successfully!';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Test (Local Emulator)'),
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
                'Test PhonePe Payment Integration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Testing with local Firebase Functions emulator:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Text(
                  'http://127.0.0.1:5001/pelviease-website/us-central1/'),
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
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Instructions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Make sure Firebase Functions emulator is running:\n'
                '   firebase emulators:start --only functions\n\n'
                '2. The emulator should be running on localhost:5001\n\n'
                '3. Check the debug console for detailed logs\n\n'
                '4. Test with different amounts to verify functionality',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
