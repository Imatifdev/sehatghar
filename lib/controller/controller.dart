import 'package:flutter/material.dart';
import 'package:sehatghar/controller/provider/blogprovider.dart';

// A controller class for managing the interactions related to blogs
class BlogController {
  final BlogModel _model;

  BlogController(this._model);

  // Method to fetch blogs from the API using the BlogModel
  Future<void> fetchBlogs(BuildContext context) async {
    // Call the fetchBlogs method in the BlogModel to fetch blogs
    await _model.fetchBlogs(context);
  }
}
