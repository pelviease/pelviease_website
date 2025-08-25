import 'package:pelviease_website/backend/models/cart_model.dart';

/// Temporary storage for order data during payment process
class PaymentOrderData {
  static PaymentOrderData? _instance;

  List<CartItem>? cartItems;
  String? userId;
  String? userName;
  String? phoneNumber;
  double? discount;
  String? selectedAddress;

  PaymentOrderData._();

  static PaymentOrderData get instance {
    _instance ??= PaymentOrderData._();
    return _instance!;
  }

  void storeOrderData({
    required List<CartItem> cartItems,
    required String userId,
    required String userName,
    required String phoneNumber,
    required double discount,
  }) {
    this.cartItems = cartItems;
    this.userId = userId;
    this.userName = userName;
    this.phoneNumber = phoneNumber;
    this.discount = discount;
  }

  void clear() {
    cartItems = null;
    userId = null;
    userName = null;
    phoneNumber = null;
    discount = null;
    selectedAddress = null;
  }

  bool get hasData => cartItems != null && userId != null;
}
