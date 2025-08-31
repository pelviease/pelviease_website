import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service to handle interactions with PhonePe via Firebase Cloud Functions.
class PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Initiates a payment by calling the backend.
  ///
  /// This function calls the 'initiatePhonePePayment' cloud function,
  /// launches the returned payment URL, and returns the `merchantOrderId`
  /// which you must save to check the payment status later.
  ///
  /// - [amountInPaise]: The amount to be paid, in the smallest currency unit (e.g., paise).
  ///
  /// Returns the `merchantOrderId` on success. Throws an exception on failure.
  Future<String> initiatePayment({required int amountInPaise}) async {
    if (kDebugMode) {
      print('Initiating payment for amount: $amountInPaise paise');
    }

    // Check if user is authenticated
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw 'User must be logged in to initiate payment';
    }

    if (kDebugMode) {
      print('User authenticated: ${currentUser.uid}');
    }

    try {
      // 1. Get a reference to the callable function
      final HttpsCallable callable =
          _functions.httpsCallable('initiatePhonePePayment');

      // 2. Call the function with the amount
      final HttpsCallableResult<Map<String, dynamic>> response =
          await callable.call<Map<String, dynamic>>({
        'amount': amountInPaise,
      });

      if (kDebugMode) {
        print('Cloud function response: ${response.data}');
      }

      // 3. Get the redirect URL and merchantOrderId from the response
      final String? redirectUrl = response.data['redirectUrl'];
      final String? merchantOrderId = response.data['merchantOrderId'];

      if (redirectUrl != null && merchantOrderId != null) {
        if (kDebugMode) {
          print('Redirect URL received: $redirectUrl');
          print('Merchant Order ID: $merchantOrderId');
        }

        // 4. Launch the payment URL
        final uri = Uri.parse(redirectUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          // 5. Return the merchant Order ID to the caller
          return merchantOrderId;
        } else {
          throw 'Could not launch $redirectUrl';
        }
      } else {
        throw 'Could not get redirect URL from Firebase.';
      }
    } on FirebaseFunctionsException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print('Cloud Function Error: ${e.code} - ${e.message}');
        print('Error details: ${e.details}');
      }
      // Provide a user-friendly error message
      throw 'Payment failed: ${e.message ?? "An unknown error occurred."}';
    } catch (e) {
      // Handle other errors (e.g., URL launch failure)
      if (kDebugMode) {
        print('Generic Error in initiatePayment: $e');
      }
      throw 'Payment initialization failed: $e';
    }
  }

  /// Checks the final status of a transaction from the backend.
  ///
  /// This should be called after the user is redirected back to the app from the
  /// PhonePe payment page.
  ///
  /// - [merchantOrderId]: The unique ID you received from [initiatePayment].
  ///
  /// Returns a `Map<String, dynamic>` containing the transaction status details.
  /// Example success response:
  /// { "status": "SUCCESS", "merchantOrderId": "...", "phonePeDetails": {...} }
  Future<Map<String, dynamic>> checkPaymentStatus(
      {required String merchantOrderId}) async {
    if (kDebugMode) {
      print('Checking payment status for merchantOrderId: $merchantOrderId');
    }

    // Check if user is authenticated
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw 'User must be logged in to check payment status';
    }

    if (kDebugMode) {
      print('User authenticated: ${currentUser.uid}');
    }

    try {
      // 1. Get a reference to the callable function
      final HttpsCallable callable =
          _functions.httpsCallable('checkPaymentStatus');

      // 2. Call the function with the merchantOrderId
      final HttpsCallableResult<Map<String, dynamic>> response =
          await callable.call<Map<String, dynamic>>({
        'merchantOrderId': merchantOrderId,
      });

      if (kDebugMode) {
        print('Check status response: ${response.data}');
      }

      // 3. Return the full response data
      return response.data;
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print('Cloud Function Error on status check: ${e.code} - ${e.message}');
        print('Error details: ${e.details}');
      }
      throw 'Failed to verify payment: ${e.message ?? "An unknown error occurred."}';
    } catch (e) {
      if (kDebugMode) {
        print('Generic Error in checkPaymentStatus: $e');
      }
      throw 'An error occurred while checking payment status: $e';
    }
  }
}
