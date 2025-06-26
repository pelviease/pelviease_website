import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/cart_service.dart';
import 'package:pelviease_website/backend/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  CartProvider() {
    fetchCartItems();
  }
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get shipping => 0.00;
  double get couponDiscount => 0.00;
  double get total => subtotal + shipping - couponDiscount;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Fetch cart items
  Future<void> fetchCartItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cartItems = await _cartService.getCartItems();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add item to cart
  Future<void> addItem(CartItem item) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _cartService.addCartItem(item);
      _cartItems.add(item);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String id, int newQuantity) async {
    try {
      final item = _cartItems.firstWhere((item) => item.id == id);
      if (newQuantity <= 0) {
        await _cartService.removeCartItem(id);
        _cartItems.removeWhere((item) => item.id == id);
      } else {
        final updatedItem = CartItem(
          productId: item.productId,
          id: item.id,
          productName: item.productName,
          description: item.description,
          price: item.price,
          quantity: newQuantity,
          image: item.image,
        );
        await _cartService.updateCartItem(updatedItem);
        _cartItems[_cartItems.indexWhere((item) => item.id == id)] =
            updatedItem;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Remove item
  Future<void> removeItem(String id) async {
    try {
      await _cartService.removeCartItem(id);
      _cartItems.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void removeProductItem(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      _cartItems.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
