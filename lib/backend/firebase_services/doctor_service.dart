import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelviease_website/backend/models/our_content.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'doctors';

  // Fetch all doctors from Firestore - Called only once
  Future<List<Doctor>> fetchDoctorsOnce() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(_collection).orderBy('name').get();

      return querySnapshot.docs
          .map((doc) => Doctor.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching doctors: $e');
      throw Exception('Failed to fetch doctors');
    }
  }
}
