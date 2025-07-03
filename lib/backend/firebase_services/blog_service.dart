import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelviease_website/backend/models/blog.dart';

class BlogService {
  final CollectionReference _blogsCollection =
      FirebaseFirestore.instance.collection('blogs');

  Stream<List<Blog>> getBlogs() {
    return _blogsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Blog.fromMap(data);
      }).toList();
    });
  }

  Future<List<Blog>> fetchBlogsList() async {
    try {
      final querySnapshot =
          await _blogsCollection.orderBy('timestamp', descending: true).get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Blog.fromMap(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
