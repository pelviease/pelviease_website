import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';

class OrderService {
  // final FirebaseFirestore _firestore = ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('orders');

  Future<List<OrderDetails>> getOrders() async {
    final user = _auth.currentUser;
    String? userId;

    try {
      if (user != null) {
        userId = user.uid;
      }

      Query query = _collectionReference;
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderDetails.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
