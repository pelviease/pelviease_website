import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/blog_service.dart';
import 'package:pelviease_website/backend/models/blog.dart';

class BlogProvider extends ChangeNotifier {
  final BlogService _blogService = BlogService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;

  Stream<List<Blog>> get blogsStream => _blogService.getBlogs();

  Future<void> fetchBlogsList() async {
    _isLoading = true;
    notifyListeners();
    try {
      _blogs = await _blogService.fetchBlogsList();
    } catch (e) {
      _blogs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
