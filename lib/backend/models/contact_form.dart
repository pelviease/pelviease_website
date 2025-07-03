import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String? id;
  final String name;
  final String? phone;
  final String email;
  final String? company;
  final String subject;
  final String question;
  final Timestamp createdAt;

  ContactModel({
    this.id,
    required this.name,
    this.phone,
    required this.email,
    this.company,
    required this.subject,
    required this.question,
    required this.createdAt,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'company': company,
      'subject': subject,
      'question': question,
      'createdAt': createdAt,
    };
  }

  // Create model from Firestore document
  factory ContactModel.fromMap(Map<String, dynamic> map, String id) {
    return ContactModel(
      id: id,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      email: map['email'] as String,
      company: map['company'] as String?,
      subject: map['subject'] as String,
      question: map['question'] as String,
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}
