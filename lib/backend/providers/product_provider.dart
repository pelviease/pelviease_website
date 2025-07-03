import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/product_service.dart';
import 'package:pelviease_website/backend/models/product_model.dart';
import 'package:pelviease_website/const/enums/payment_enum.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Map<String, String>> productsId = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, String>> get productsIdList => productsId;

  ProductProvider() {
    _initProductsStream();
  }

  // Initialize stream to listen for product updates
  void _initProductsStream() {
    _productService.getProducts().listen(
      (products) {
        _products = products;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Fetch product by ID
  Future<Product?> getProductById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final product = await _productService.getProductById(id);
      _isLoading = false;
      notifyListeners();
      return product;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Handle product purchase
  Future<bool> purchaseProduct({
    required String userId,
    required String productId,
    required PaymentType paymentType,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _productService.purchaseProduct(
        userId: userId,
        productId: productId,
        paymentType: paymentType,
      );
      _isLoading = false;
      if (!success) {
        _error = 'Failed to complete purchase';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<Map<String, String>>> fetchProductsId() async {
    try {
      final productsList = await _productService.getProducts().first;
      // print(
      //     "Products ID in provider: ${productsList.map((product) => product.id).toList()}");
      productsId = productsList
          .map((product) => {
                'id': product.id,
                'name': product.name,
              })
          .toList();
      return productsId;
    } catch (error) {
      // print("Error fetching products ID: $error");
      return [];
    }
  }
}
