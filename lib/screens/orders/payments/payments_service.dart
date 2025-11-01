// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js_util';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pelviease_website/const/razorpay_config.dart';
import 'package:pelviease_website/screens/orders/payments/razorpay_web.dart';

/// Service to handle Razorpay payments and Firebase integration.
class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Initiates a Razorpay payment.
  ///
  /// This function:
  /// 1. Creates a transaction document in Firebase with PENDING status
  /// 2. Opens the Razorpay checkout UI
  /// 3. On success, creates an order in the orders collection
  ///
  /// - [amountInPaise]: The amount to be paid in paise (₹1 = 100 paise).
  /// - [orderId]: Optional custom order ID. If not provided, will auto-generate.
  /// - [userEmail]: User's email for prefill (optional).
  /// - [userPhone]: User's phone number for prefill (optional).
  /// - [userName]: User's name for prefill (optional).
  /// - [metaInfo]: Additional metadata to store with the transaction (optional).
  /// - [orderData]: Additional order data to store in orders collection on success (optional).
  ///
  /// Returns the orderId on success.
  /// Throws an exception on failure.
  Future<String> initiatePayment({
    required int amountInPaise,
    String? orderId,
    String? userEmail,
    String? userPhone,
    String? userName,
    Map<String, dynamic>? metaInfo,
    Map<String, dynamic>? orderData,
  }) async {
    if (kDebugMode) {
      print(
          '🚀 Initiating Razorpay payment for amount: ₹${amountInPaise / 100}');
    }

    // Check if user is authenticated
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User must be logged in to initiate payment');
    }

    if (kDebugMode) {
      print('✅ User authenticated: ${currentUser.uid}');
    }

    // Validate amount
    if (amountInPaise <= 0) {
      throw Exception('Amount must be greater than zero');
    }

    try {
      // Step 1: Generate orderId
      final generatedOrderId = orderId ??
          'ORDER-${DateTime.now().millisecondsSinceEpoch}-${currentUser.uid.substring(0, 8)}';

      // Step 2: Create transaction document in Firebase with PENDING status
      final transactionRef =
          _firestore.collection('transactions').doc(generatedOrderId);

      final transactionData = {
        'userId': currentUser.uid,
        'orderId': generatedOrderId, // Store orderId reference
        'amount': amountInPaise,
        'status': 'PENDING',
        'paymentGateway': 'razorpay',
        'currency': RazorpayConfig.currency,
        'createdAt': FieldValue.serverTimestamp(),
        if (metaInfo != null) 'metaInfo': metaInfo,
        if (userEmail != null) 'userEmail': userEmail,
        if (userName != null) 'userName': userName,
        if (userPhone != null) 'userPhone': userPhone,
        if (orderData != null)
          'orderData': orderData, // Store order data for later
      };

      await transactionRef.set(transactionData);

      if (kDebugMode) {
        print(
            '📝 Transaction created in Firebase with orderId: $generatedOrderId');
      }

      // Step 3: Prepare Razorpay options
      final options = RazorpayOptions(
        key: RazorpayConfig.keyId,
        amount: amountInPaise.toString(),
        currency: RazorpayConfig.currency,
        name: RazorpayConfig.companyName,
        description: 'Order #$generatedOrderId',
        image: RazorpayConfig.companyLogo,
        order_id:
            null, // Optional: Create Razorpay order on backend for extra security
        handler: allowInterop((response) {
          _handlePaymentSuccess(response, generatedOrderId);
        }),
        prefill: jsify({
          'name': userName ?? currentUser.displayName ?? '',
          'email': userEmail ?? currentUser.email ?? '',
          'contact': userPhone ?? '',
        }),
        notes: jsify(metaInfo ?? {}),
        theme: jsify({
          'color': RazorpayConfig.themeColor,
        }),
        modal: jsify({
          'ondismiss': allowInterop(() {
            _handlePaymentDismissed(generatedOrderId);
          }),
        }),
      );

      // Step 4: Initialize Razorpay and set up event listeners
      final razorpay = Razorpay(options);

      razorpay.on('payment.failed', allowInterop((errorResponse) {
        _handlePaymentFailure(errorResponse, generatedOrderId);
      }));

      // Step 5: Open Razorpay checkout
      razorpay.open();

      if (kDebugMode) {
        print('💳 Razorpay checkout opened');
      }

      return generatedOrderId;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initiating payment: $e');
      }
      rethrow;
    }
  }

  /// Handles successful payment
  /// Updates transaction and creates order in orders collection
  void _handlePaymentSuccess(dynamic response, String orderId) async {
    try {
      final paymentId = getProperty(response, 'razorpay_payment_id') as String?;
      final razorpayOrderId =
          getProperty(response, 'razorpay_order_id') as String?;
      final signature = getProperty(response, 'razorpay_signature') as String?;

      if (kDebugMode) {
        print('✅ Payment successful!');
        print('Payment ID: $paymentId');
        print('Razorpay Order ID: $razorpayOrderId');
        print('Signature: $signature');
      }

      // Get transaction data to retrieve orderData
      final transactionDoc =
          await _firestore.collection('transactions').doc(orderId).get();
      final transactionData = transactionDoc.data();
      final orderData = transactionData?['orderData'] as Map<String, dynamic>?;
      final amount = transactionData?['amount'] as int?;
      final userId = transactionData?['userId'] as String?;
      final userEmail = transactionData?['userEmail'] as String?;
      final userName = transactionData?['userName'] as String?;
      final userPhone = transactionData?['userPhone'] as String?;
      final metaInfo = transactionData?['metaInfo'] as Map<String, dynamic>?;

      // Update transaction in Firebase
      await _firestore.collection('transactions').doc(orderId).update({
        'status': 'SUCCESS',
        'state': 'SUCCESS',
        'razorpayPaymentId': paymentId,
        'razorpayOrderId': razorpayOrderId,
        'razorpaySignature': signature,
        'lastStatusCheckAt': FieldValue.serverTimestamp(),
        'completedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('📝 Transaction updated in Firebase with SUCCESS status');
      }

      // Create order in orders collection with same orderId
      final orderDocument = {
        'orderId': orderId,
        'userId': userId,
        'amount': amount,
        'currency': RazorpayConfig.currency,
        'status': 'PAID',
        'paymentStatus': 'SUCCESS',
        'paymentGateway': 'razorpay',
        'razorpayPaymentId': paymentId,
        'razorpayOrderId': razorpayOrderId,
        'razorpaySignature': signature,
        'createdAt': FieldValue.serverTimestamp(),
        'paidAt': FieldValue.serverTimestamp(),
        if (userEmail != null) 'userEmail': userEmail,
        if (userName != null) 'userName': userName,
        if (userPhone != null) 'userPhone': userPhone,
        if (metaInfo != null) 'metaInfo': metaInfo,
        // Merge any additional order data provided during initiation
        if (orderData != null) ...orderData,
      };

      await _firestore.collection('orders').doc(orderId).set(orderDocument);

      if (kDebugMode) {
        print('📦 Order created in orders collection with orderId: $orderId');
      }

      // TODO: You can trigger additional actions here like:
      // - Show success message to user
      // - Navigate to order confirmation page
      // - Send confirmation email
      // - Update inventory
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error handling payment success: $e');
      }
    }
  }

  /// Handles payment failure
  void _handlePaymentFailure(dynamic errorResponse, String orderId) async {
    try {
      final code = getProperty(errorResponse, 'code') as String? ?? 'unknown';
      final description =
          getProperty(errorResponse, 'description') as String? ??
              'Payment failed';
      final source =
          getProperty(errorResponse, 'source') as String? ?? 'unknown';
      final step = getProperty(errorResponse, 'step') as String? ?? 'unknown';
      final reason =
          getProperty(errorResponse, 'reason') as String? ?? 'unknown';

      if (kDebugMode) {
        print('❌ Payment failed!');
        print('Code: $code');
        print('Description: $description');
        print('Source: $source');
        print('Step: $step');
        print('Reason: $reason');
      }

      // Update transaction in Firebase
      await _firestore.collection('transactions').doc(orderId).update({
        'status': 'FAILED',
        'state': 'FAILED',
        'errorCode': code,
        'errorDescription': description,
        'errorSource': source,
        'errorStep': step,
        'errorReason': reason,
        'lastStatusCheckAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('📝 Transaction updated in Firebase with FAILED status');
      }

      // TODO: Show error message to user
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error handling payment failure: $e');
      }
    }
  }

  /// Handles when user dismisses the payment modal
  void _handlePaymentDismissed(String orderId) async {
    try {
      if (kDebugMode) {
        print('⚠️ Payment modal dismissed by user');
      }

      // Update transaction status to CANCELLED
      await _firestore.collection('transactions').doc(orderId).update({
        'status': 'CANCELLED',
        'state': 'CANCELLED',
        'lastStatusCheckAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('📝 Transaction updated in Firebase with CANCELLED status');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error handling payment dismissal: $e');
      }
    }
  }

  /// Retrieves transaction details from Firebase
  ///
  /// - [orderId]: The order ID
  ///
  /// Returns a map containing the transaction details.
  Future<Map<String, dynamic>?> getTransactionDetails(String orderId) async {
    try {
      final doc =
          await _firestore.collection('transactions').doc(orderId).get();

      if (!doc.exists) {
        if (kDebugMode) {
          print('❌ Transaction not found: $orderId');
        }
        return null;
      }

      return doc.data();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching transaction details: $e');
      }
      rethrow;
    }
  }

  /// Retrieves order details from Firebase
  ///
  /// - [orderId]: The order ID
  ///
  /// Returns a map containing the order details.
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();

      if (!doc.exists) {
        if (kDebugMode) {
          print('❌ Order not found: $orderId');
        }
        return null;
      }

      return doc.data();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching order details: $e');
      }
      rethrow;
    }
  }

  /// Gets all transactions for the current user
  ///
  /// - [limit]: Maximum number of transactions to fetch (default: 50)
  /// - [status]: Filter by transaction status (optional)
  ///
  /// Returns a list of transaction documents.
  Future<List<Map<String, dynamic>>> getUserTransactions({
    int limit = 50,
    String? status,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User must be logged in to fetch transactions');
      }

      Query query = _firestore
          .collection('transactions')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['orderId'] = doc.id; // Use orderId as the identifier
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching user transactions: $e');
      }
      rethrow;
    }
  }

  /// Gets all orders for the current user
  ///
  /// - [limit]: Maximum number of orders to fetch (default: 50)
  /// - [status]: Filter by order status (optional)
  ///
  /// Returns a list of order documents.
  Future<List<Map<String, dynamic>>> getUserOrders({
    int limit = 50,
    String? status,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User must be logged in to fetch orders');
      }

      Query query = _firestore
          .collection('orders')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['orderId'] = doc.id; // Use orderId as the identifier
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching user orders: $e');
      }
      rethrow;
    }
  }

  /// Verifies payment signature (for additional security)
  ///
  /// Note: This should ideally be done on the backend for security.
  /// For now, we just validate that required fields exist.
  bool validatePaymentResponse({
    required String? paymentId,
    required String? orderId,
    required String? signature,
  }) {
    if (paymentId == null || orderId == null || signature == null) {
      return false;
    }

    // TODO: Implement actual signature verification using crypto
    // This requires your Razorpay secret key, which should NEVER be exposed on client side
    // Signature verification MUST be done on backend

    return paymentId.isNotEmpty && orderId.isNotEmpty && signature.isNotEmpty;
  }
}
