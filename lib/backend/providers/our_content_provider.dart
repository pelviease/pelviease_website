import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/our_content_service.dart';
import 'package:pelviease_website/backend/models/our_content.dart';

class ContentProvider with ChangeNotifier {
  final ContentService _contentService = ContentService();

  Stream<List<WatchContent>> get watchContents =>
      _contentService.getWatchContents();
  Stream<List<Testimony>> get testimonials => _contentService.getTestimonials();
}
