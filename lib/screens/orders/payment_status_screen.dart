import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentStatusScreen extends StatefulWidget {
  final String? transactionId;

  const PaymentStatusScreen({super.key, required this.transactionId});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.transactionId == null || widget.transactionId!.isEmpty) {
      return _buildStatusView(
        icon: Icons.error_outline,
        color: Colors.red,
        message: "Transaction ID not found.\nPlease contact support.",
        isSuccess: false,
      );
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .doc(widget.transactionId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildStatusView(
              icon: null,
              color: Colors.blue,
              message: "Confirming payment status...",
              isSuccess: false,
            );
          }

          // 2. If there's an error or no data
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return _buildStatusView(
              icon: Icons.error_outline,
              color: Colors.red,
              message: "Transaction not found or an error occurred.",
              isSuccess: false,
            );
          }

          // 3. We have data, so let's check the status
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'] as String;

          switch (status) {
            case 'SUCCESS':
              return _buildStatusView(
                icon: Icons.check_circle,
                color: Colors.green,
                message: "Payment Successful!",
                isSuccess: true,
              );
            case 'FAILED':
              return _buildStatusView(
                icon: Icons.cancel,
                color: Colors.red,
                message: "Payment Failed.\nPlease try again.",
                isSuccess: false,
              );
            case 'PENDING':
            default:
              return _buildStatusView(
                icon: null, // Still processing
                color: Colors.orange,
                message: "Payment is pending.\nPlease wait...",
                isSuccess: false,
              );
          }
        },
      ),
    );
  }

  Widget _buildStatusView({
    required IconData? icon,
    required Color color,
    required String message,
    required bool isSuccess,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, size: 100, color: color)
          else
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(color)),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.go('/');
            },
            child: Text(isSuccess ? "Go to Home" : "Try Again"),
          )
        ],
      ),
    );
  }
}
