# Razorpay Integration Guide for Flutter Web

## 🎉 What's Been Updated

Your payment system has been migrated from **PhonePe** to **Razorpay**. All payments are now handled directly in the browser using Razorpay's checkout modal, and order data is stored in Firebase Firestore.

---

## 📁 Files Modified/Created

### 1. **web/index.html**
   - ✅ Added Razorpay checkout script

### 2. **lib/screens/orders/payments/razorpay_web.dart** (NEW)
   - JavaScript interop for Razorpay
   - Defines Razorpay classes, options, and response types

### 3. **lib/const/razorpay_config.dart** (NEW)
   - Configuration file for Razorpay credentials
   - **⚠️ IMPORTANT: Update `keyId` with your actual Razorpay Key ID**

### 4. **lib/screens/orders/payments/payments_service.dart**
   - ✅ Completely rewritten to use Razorpay
   - ✅ No longer uses Cloud Functions
   - ✅ Stores orders directly in Firebase Firestore
   - ✅ Handles payment callbacks (success/failure/cancelled)

### 5. **lib/screens/orders/payments/payment_test_screen.dart**
   - ✅ Updated UI for Razorpay testing
   - ✅ Added customer details prefill fields
   - ✅ Added order management features (view orders, check status)

### 6. **pubspec.yaml**
   - ✅ Added `js: ^0.7.1` dependency for JavaScript interop

---

## 🚀 Setup Instructions

### Step 1: Get Razorpay Credentials

1. Go to [Razorpay Dashboard](https://dashboard.razorpay.com)
2. Sign up or log in
3. Navigate to **Settings** → **API Keys**
4. Copy your **Key ID** (starts with `rzp_test_` or `rzp_live_`)

### Step 2: Update Configuration

Open `lib/const/razorpay_config.dart` and replace the placeholder:

```dart
static const String keyId = 'rzp_test_YOUR_KEY_HERE'; // Replace this!
```

### Step 3: Configure Firebase

Make sure your Firestore security rules allow authenticated users to create and read transactions:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /transactions/{merchantOrderId} {
      // Allow users to create transactions
      allow create: if request.auth != null
                    && request.resource.data.userId == request.auth.uid;

      // Allow users to read their own transactions
      allow read: if request.auth != null
                  && resource.data.userId == request.auth.uid;

      // Allow system to update transactions (for payment callbacks)
      allow update: if request.auth != null
                    && resource.data.userId == request.auth.uid;
    }
  }
}
```

### Step 4: Test the Integration

1. Run your app: `flutter run -d chrome`
2. Navigate to the payment test screen
3. Make sure you're logged in
4. Enter test details and click "Pay with Razorpay"
5. Use test card: `4111 1111 1111 1111`
6. Enter any future expiry date and CVV

---

## 💳 Test Cards

Razorpay provides test cards for development:

| Card Number         | Type    | Result  |
|---------------------|---------|---------|
| 4111 1111 1111 1111 | Visa    | Success |
| 5555 5555 5555 4444 | MC      | Success |
| 4000 0000 0000 0002 | Visa    | Failure |

*Use any future expiry date and any CVV*

---

## 📊 Firebase Data Structure

Transactions are stored in the `transactions` collection (matching PhonePe implementation) with this structure:

```javascript
{
  "userId": "firebase_user_id",
  "amount": 1000,  // in paise
  "status": "SUCCESS" | "FAILED" | "PENDING" | "CANCELLED",
  "state": "SUCCESS" | "FAILED" | "PENDING" | "CANCELLED",  // mirrors status
  "merchantOrderId": "ORDER-1730419200000-abc12345",
  "paymentGateway": "razorpay",
  "currency": "INR",
  "razorpayPaymentId": "pay_xxxxx",  // on success
  "razorpayOrderId": "order_xxxxx",  // optional
  "razorpaySignature": "xxxxx",      // optional
  "createdAt": Timestamp,
  "lastStatusCheckAt": Timestamp,
  "completedAt": Timestamp,          // on success
  "metaInfo": {                      // optional custom data
    "productId": "xxx",
    "description": "xxx"
  },
  "userEmail": "user@example.com",   // optional
  "userName": "John Doe",            // optional
  "userPhone": "9876543210"          // optional
}
```

---

## 🔧 How It Works

### Payment Flow

1. **User clicks "Pay with Razorpay"**
   - `PaymentService.initiatePayment()` is called
   - Creates transaction document in Firebase `transactions` collection with `PENDING` status
   - Generates `merchantOrderId` (e.g., `ORDER-1730419200000-abc12345`)

2. **Razorpay modal opens**
   - User enters payment details
   - Razorpay processes payment

3. **Payment Success**
   - `_handlePaymentSuccess()` callback fires
   - Updates transaction status to `SUCCESS` and state to `SUCCESS`
   - Stores payment ID, signature, etc.

4. **Payment Failure**
   - `_handlePaymentFailure()` callback fires
   - Updates transaction status to `FAILED` and state to `FAILED`
   - Stores error details

5. **User Closes Modal**
   - `_handlePaymentDismissed()` callback fires
   - Updates transaction status to `CANCELLED` and state to `CANCELLED`

---

## 🎯 Key Features

### ✅ Real-time Transaction Updates
- All transaction status changes are instantly saved to Firebase
- No need to manually check payment status
- Automatic callbacks handle everything

### ✅ Customer Information Prefill
- Auto-fill name, email, phone from Firebase Auth
- Or manually provide customer details
- Better conversion rates with prefilled data

### ✅ Transaction Management
- View all user transactions with `getUserTransactions()`
- Check specific transaction status with `getTransactionDetails()`
- Filter transactions by status

### ✅ Secure & Direct
- No backend/cloud functions needed for basic payments
- All payment processing done by Razorpay
- Transaction data securely stored in Firebase

### ✅ PhonePe-Compatible Structure
- Uses same `transactions` collection
- Same field naming convention (`merchantOrderId`, `status`, `state`)
- Easy migration from PhonePe

---

## ⚠️ Security Notes

### Current Implementation
- ✅ Transaction creation and updates happen client-side
- ✅ Firebase security rules protect user data
- ✅ Only authenticated users can create/view transactions
- ✅ Uses same `transactions` collection as PhonePe

### For Production (Recommended)
Consider adding backend verification:
1. Create Razorpay orders on backend with order_id
2. Verify payment signatures on backend
3. Update transaction status only after verification

This prevents:
- Tampering with payment amounts
- Fake payment confirmations
- Unauthorized transaction access

---

## 📝 Usage Example

```dart
// In your checkout page
final paymentService = PaymentService();

try {
  final merchantOrderId = await paymentService.initiatePayment(
    amountInPaise: 50000,  // ₹500
    userName: 'John Doe',
    userEmail: 'john@example.com',
    userPhone: '9876543210',
    metaInfo: {
      'productId': 'PROD123',
      'cartId': 'CART456',
    },
  );

  print('Payment initiated: $merchantOrderId');
  // Razorpay modal opens automatically
  // Transaction status updates happen automatically via callbacks

} catch (e) {
  print('Payment failed: $e');
}

// Later, check transaction status
final transactionDetails = await paymentService.getTransactionDetails(merchantOrderId);
print('Payment status: ${transactionDetails?['status']}');

// Or get all user transactions
final transactions = await paymentService.getUserTransactions(limit: 10);
for (var transaction in transactions) {
  print('Transaction ${transaction['merchantOrderId']}: ${transaction['status']}');
}
```

---

## 🐛 Troubleshooting

### Issue: "Razorpay is not defined"
**Solution:** Make sure `<script src="https://checkout.razorpay.com/v1/checkout.js"></script>` is in `web/index.html`

### Issue: "Key ID not configured"
**Solution:** Update `RazorpayConfig.keyId` in `lib/const/razorpay_config.dart`

### Issue: "Transactions not showing in Firebase"
**Solution:** Check Firestore security rules and ensure user is authenticated

### Issue: Payment callback not firing
**Solution:** Check browser console for JavaScript errors, ensure `js` package is installed

---

## 🔄 Migration from PhonePe

The old PhonePe implementation can be safely removed:

### Files to Delete (Optional)
- ❌ `functions/src/index.ts` (PhonePe cloud functions)
- ❌ `functions/package.json`
- ❌ Any PhonePe-related cloud function code

### Environment Variables (No longer needed)
- ❌ PHONEPE_MERCHANT_ID
- ❌ PHONEPE_CLIENT_ID
- ❌ PHONEPE_SALT_KEY

---

## 📚 Resources

- [Razorpay Web Integration Docs](https://razorpay.com/docs/payments/payment-gateway/web-integration/)
- [Razorpay Dashboard](https://dashboard.razorpay.com)
- [Test Cards & Scenarios](https://razorpay.com/docs/payments/payments/test-card-details/)
- [Flutter Web Dart-JS Interop](https://dart.dev/web/js-interop)

---

## ✨ Next Steps

1. Update Razorpay Key ID in configuration
2. Test with test cards
3. Set up Firebase security rules
4. (Optional) Add backend order verification for production
5. Customize order notes/metadata for your use case
6. Style the payment test screen to match your brand

---

**Happy coding! 🚀**
