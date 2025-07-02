import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelviease_website/backend/models/our_content.dart';

class ContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<WatchContent>> getWatchContents() {
    return _firestore.collection('watchContents').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => WatchContent.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Testimony>> getTestimonials() {
    return _firestore.collection('testimonials').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Testimony.fromMap(doc.data(), doc.id))
            .toList());
  }
}
