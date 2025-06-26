import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/order_item_service.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<OrderDetails> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderDetails> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> fetchOrders() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _orders = await _orderService.getOrders();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> placeOrder(
  //     OrderItem order, String userId, String userName) async {
  //   _setLoading(true);
  //   _errorMessage = null;

  //   try {
  //     await _orderService.placeOrder(order, userId, userName);
  //     _orders.add(order);
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //   } finally {
  //     _setLoading(false);
  //   }
  // }
}
