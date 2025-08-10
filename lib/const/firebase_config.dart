import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration utilities
class FirebaseConfig {
  /// Set to true when you want to use the local Firebase Functions emulator
  /// This should be false for production builds
  static const bool useEmulator =
      false; // Change this to true when testing locally with emulator

  /// Initialize Firebase Functions with appropriate configuration
  static void configureFunctions() {
    if (useEmulator && kDebugMode) {
      // Only use emulator in debug mode and when explicitly enabled
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5002);
      if (kDebugMode) {
        print(
            '🔧 Firebase Functions configured to use local emulator on localhost:5002');
      }
    } else {
      if (kDebugMode) {
        print('🚀 Firebase Functions configured to use production endpoints');
      }
    }
  }

  /// Check if we're currently using the emulator
  static bool get isUsingEmulator => useEmulator && kDebugMode;
}
