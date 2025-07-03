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

class WatchContent {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;

  WatchContent({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.caption,
  });

  factory WatchContent.fromMap(Map<String, dynamic> data, String id) {
    return WatchContent(
      id: id,
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      caption: data['caption'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
    };
  }
}

class Testimony {
  final String id;
  final String name;
  final String testimony;
  final String about;

  Testimony({
    required this.id,
    required this.name,
    required this.testimony,
    required this.about,
  });

  factory Testimony.fromMap(Map<String, dynamic> data, String id) {
    return Testimony(
      id: id,
      name: data['name'] ?? '',
      testimony: data['testimony'] ?? '',
      about: data['about'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'testimony': testimony,
      'about': about,
    };
  }
}
