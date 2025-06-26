import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _getOrdersCollection([String? userId]) {
    return _firestore.collection('orders');
  }

  Future<void> placeOrder(
      OrderItem order, String userId, String userName) async {
    // print('Attempting to place order with initial ID: ${order.id}');
    try {
      final docRef = await _firestore.collection('orders').add(order.toMap());
      await docRef
          .update({'id': docRef.id, 'userId': userId, 'userName': userName});
      // print('Order placed successfully with Firestore ID: $docRef.id');
    } catch (e) {
      print('Failed to place order: $e');
      throw Exception('Failed to place order: $e');
    }
  }

  Future<List<OrderItem>> getOrders([String? userId]) async {
    try {
      final snapshot = await _getOrdersCollection(userId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderItem(
          id: doc.id,
          userId: userId ?? data['userId'] as String,
          productId: data['productId'] as String,
          userName: data['userName'] as String,
          productName: data['productName'] as String,
          description: data['description'] as String,
          price: (data['price'] as num).toDouble(),
          quantity: data['quantity'] as int,
          image: data['image'] as String,
          address: data['address'] as Map<String, String>,
          paymentType: data['paymentType'] as String,
          orderDate: (data['orderDate'] as Timestamp).toDate(),
          status: data['status'] as String,
          trackingUrl: data['trackingUrl'] as String? ?? '',
          phoneNumber: data['phoneNumber'] as String? ?? '',
        );
      }).toList();
    } catch (e) {
      print('Failed to fetch orders: $e');
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
