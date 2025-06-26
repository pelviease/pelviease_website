import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';

class CheckoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new order
  Future<void> createOrder(OrderDetails order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toMap());
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Add user address
  Future<void> addUserAddress(DeliveryAddress address) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(address.id)
          .set(address.toMap());
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  // Get user addresses
  Future<List<DeliveryAddress>> getUserAddresses() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();
      return snapshot.docs
          .map((doc) => DeliveryAddress.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }
}
