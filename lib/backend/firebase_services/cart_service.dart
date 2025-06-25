import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelviease_website/backend/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's cart collection reference
  CollectionReference _getCartCollection() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  // Add a new cart item
  Future<void> addCartItem(CartItem item) async {
    try {
      await _getCartCollection().doc(item.id).set({
        'productId': item.productId,
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'quantity': item.quantity,
        'image': item.image,
      });
    } catch (e) {
      throw Exception('Failed to add cart item: $e');
    }
  }

  // Fetch cart items
  Future<List<CartItem>> getCartItems() async {
    try {
      final snapshot = await _getCartCollection().get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartItem(
          productId: data['productId'] as String,
          id: doc.id,
          name: data['name'] as String,
          description: data['description'] as String,
          price: (data['price'] as num).toDouble(),
          quantity: data['quantity'] as int,
          image: data['image'] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  // Add or update cart item
  Future<void> updateCartItem(CartItem item) async {
    try {
      await _getCartCollection().doc(item.id).set({
        'productId': item.productId,
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'quantity': item.quantity,
        'image': item.image,
      });
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  // Remove cart item
  Future<void> removeCartItem(String id) async {
    try {
      await _getCartCollection().doc(id).delete();
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      final snapshot = await _getCartCollection().get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
