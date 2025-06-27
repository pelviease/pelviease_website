import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/checkout_service.dart';
import 'package:pelviease_website/backend/models/cart_model.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';
import 'package:pelviease_website/const/enums/payment_enum.dart';
import 'package:uuid/uuid.dart';

class CheckoutProvider with ChangeNotifier {
  final CheckoutService _checkoutService = CheckoutService();
  List<DeliveryAddress> _addresses = [];
  DeliveryAddress? _selectedAddress;
  PaymentType _selectedPaymentType = PaymentType.cash;
  bool _isLoading = false;
  String? _errorMessage;

  List<DeliveryAddress> get addresses => _addresses;
  DeliveryAddress? get selectedAddress => _selectedAddress;
  PaymentType get selectedPaymentType => _selectedPaymentType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch user addresses
  Future<void> fetchAddresses() async {
    setLoading(true);
    _errorMessage = null;

    try {
      _addresses = await _checkoutService.getUserAddresses();
      if (_addresses.isNotEmpty) {
        _selectedAddress = _addresses.firstWhere(
          (address) => address.isDefault,
          orElse: () => _addresses.first,
        );
      } else {
        _selectedAddress = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  // Add new address
  Future<void> addAddress(DeliveryAddress address) async {
    setLoading(true);
    _errorMessage = null;

    try {
      await _checkoutService.addUserAddress(address);
      _addresses.add(address);
      if (address.isDefault) {
        _selectedAddress = address;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setLoading(false);
    }
  }

  // Set selected address
  void setSelectedAddress(DeliveryAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  // Set payment type
  void setPaymentType(PaymentType paymentType) {
    _selectedPaymentType = paymentType;
    notifyListeners();
  }

  Future<bool> placeOrder({
    required List<CartItem> cartItems,
    required String userId,
    required String userName,
    required String phoneNumber,
    required String userFcmToken,
    required double discount,
  }) async {
    if (_selectedAddress == null) {
      _errorMessage = 'Please select a delivery address';
      notifyListeners();
      return false;
    }

    setLoading(true);
    _errorMessage = null;
    if (cartItems.isEmpty) {
      _errorMessage = 'Your cart is empty';
      setLoading(false);
      notifyListeners();
      return false;
    }

    try {
      // Calculate order totals
      final subtotal = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + (item.price * item.quantity),
      );
      const taxRate = 0.1; // Example: 10% tax rate
      const shippingCost = 5.0; // Example: Fixed shipping cost
      final tax = subtotal * taxRate;
      final total = subtotal + tax + shippingCost - discount;

      // Create OrderDetails from cart items
      final orderDetails = OrderDetails.fromCartItems(
        id: Uuid().v4(),
        userId: userId,
        userName: userName,
        userFcmToken: userFcmToken,
        cartItems: cartItems,
        subtotal: subtotal,
        tax: tax,
        shippingCost: shippingCost,
        discount: discount,
        total: total,
        deliveryAddress: _selectedAddress!,
        paymentMethod: _selectedPaymentType,
      );

      // Assume _checkoutService.createOrder is updated to accept OrderDetails
      await _checkoutService.createOrder(orderDetails);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
