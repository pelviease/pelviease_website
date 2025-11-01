## 🚀 Quick Start - Razorpay Integration

### ⚡ What Changed?
- ✅ Migrated from PhonePe to Razorpay
- ✅ No cloud functions needed
- ✅ Direct browser integration
- ✅ Firebase Firestore for order storage

### 🔧 Setup (3 Steps)

#### 1. Get Razorpay Key
```
https://dashboard.razorpay.com/app/website-app-settings/api-keys
```

#### 2. Update Config
File: `lib/const/razorpay_config.dart`
```dart
static const String keyId = 'rzp_test_YOUR_KEY_HERE';
```

#### 3. Firebase Rules
```javascript
match /transactions/{merchantOrderId} {
  allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
  allow read: if request.auth != null && resource.data.userId == request.auth.uid;
  allow update: if request.auth != null && resource.data.userId == request.auth.uid;
}
```

### 💳 Test Cards
- Success: `4111 1111 1111 1111`
- Failure: `4000 0000 0000 0002`
- Any future expiry & CVV

### 📦 Usage
```dart
final paymentService = PaymentService();

// Initiate payment (modal opens automatically)
final merchantOrderId = await paymentService.initiatePayment(
  amountInPaise: 50000,  // ₹500
  userName: 'John Doe',
  userEmail: 'john@example.com',
  userPhone: '9876543210',
  metaInfo: {'productId': 'PROD123'},
);

// Check transaction status
final transaction = await paymentService.getTransactionDetails(merchantOrderId);
print(transaction?['status']);  // SUCCESS, FAILED, PENDING, CANCELLED

// Get all user transactions
final transactions = await paymentService.getUserTransactions(limit: 10);
```

### 📊 Order Statuses
- `PENDING` - Transaction created, payment in progress
- `SUCCESS` - Payment successful
- `FAILED` - Payment failed
- `CANCELLED` - User closed payment modal

### 🎯 Key Files
1. `lib/screens/orders/payments/payments_service.dart` - Main service
2. `lib/screens/orders/payments/razorpay_web.dart` - JS interop
3. `lib/const/razorpay_config.dart` - Configuration
4. `web/index.html` - Razorpay script included
5. `lib/screens/orders/payments/payment_test_screen.dart` - Test UI

### 🔥 Features
✨ Auto transaction creation in Firebase
✨ Real-time status updates
✨ Customer prefill support
✨ Transaction history
✨ Payment callbacks (success/failure/cancelled)
✨ PhonePe-compatible data structure

### ⚠️ Important
- Always test in test mode first (`rzp_test_...`)
- For production, add backend signature verification
- User must be authenticated to make payments
- Amounts are in paise (₹1 = 100 paise)

### 📖 Full Guide
See `RAZORPAY_INTEGRATION_GUIDE.md` for complete documentation
