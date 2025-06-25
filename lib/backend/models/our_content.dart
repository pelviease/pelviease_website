import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final String location;
  final String phone;
  final String profile;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.location,
    required this.phone,
    required this.profile,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      specialization: data['specialization'] ?? '',
      location: data['location'] ?? '',
      phone: data['phone'] ?? '',
      profile: data['profile'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'specialization': specialization,
      'location': location,
      'phone': phone,
      'profile': profile,
    };
  }
}
