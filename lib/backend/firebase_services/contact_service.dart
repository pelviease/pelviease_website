import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelviease_website/backend/models/contact_form.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'contactUs';

  // Submit contact form data to Firestore
  Future<void> submitContactForm(ContactModel contact) async {
    try {
      await _firestore.collection(_collectionPath).add(contact.toMap());
    } catch (e) {
      throw Exception('Failed to submit contact form: $e');
    }
  }
}
