import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelviease_website/backend/models/product_model.dart';
import 'package:pelviease_website/const/enums/payment_enum.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'products';

  // Stream to get all products
  Stream<List<Product>> getProducts() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson({
          ...doc.data(),
          'id': doc.id,
        });
      }).toList();
    });
  }

  // Get product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(id).get();
      if (doc.exists) {
        return Product.fromJson({
          ...doc.data()!,
          'id': doc.id,
        });
      }
      return null;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  // Purchase product
  Future<bool> purchaseProduct({
    required String userId,
    required String productId,
    required PaymentType paymentType,
  }) async {
    try {
      // Create a purchase record in a 'purchases' subcollection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('purchases')
          .add({
        'productId': productId,
        'paymentType': paymentType.toString(),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'completed',
      });

      // Update product rating count or other relevant fields if needed
      await _firestore.collection(_collectionPath).doc(productId).update({
        'totalRatingCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Error purchasing product: $e');
      return false;
    }
  }
}
