import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/blog_service.dart';
import 'package:pelviease_website/backend/models/blog.dart';

class BlogProvider extends ChangeNotifier {
  final BlogService _blogService = BlogService();
  Stream<List<Blog>> get blogsStream => _blogService.getBlogs();
}
