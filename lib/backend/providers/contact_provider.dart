import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/contact_service.dart';
import 'package:pelviease_website/backend/models/contact_form.dart';

import 'package:pelviease_website/const/toaster.dart';
import 'package:toastification/toastification.dart';

class ContactProvider with ChangeNotifier {
  final ContactService _contactService = ContactService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> submitForm({
    required String name,
    String? phone,
    required String email,
    String? company,
    required String subject,
    required String question,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final contact = ContactModel(
        name: name,
        phone: phone,
        email: email,
        company: company,
        subject: subject,
        question: question,
        createdAt: Timestamp.now(),
      );

      await _contactService.submitContactForm(contact);

      showCustomToast(
        title: 'Successful',
        type: ToastificationType.success,
        description: 'Form submitted successfully!',
      );
    } catch (e) {
      showCustomToast(
        title: 'Error',
        type: ToastificationType.error,
        description: 'Failed to submit form: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
