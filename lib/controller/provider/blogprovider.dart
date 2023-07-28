import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sehatghar/controller/utils/apiconstants.dart';
import 'dart:convert';

import '../../model/blogmodel.dart';

class BlogModel extends ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;
  int _currentPage = 1;

  // Method to fetch blogs from the API based on the current page number
  Future<void> fetchBlogs(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.fetchBlogsEndpoint}?pageNumber=$_currentPage'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _blogs = (jsonData['blogs'] as List)
            .map((item) => Blog.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to fetch blogs. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching blogs: $e'),
        ),
      );
    }
  }

  // Method to fetch the next page of blogs
  Future<void> nextPage(BuildContext context) async {
    _currentPage++;
    await fetchBlogs(context);
  }

  // Method to fetch the previous page of blogs
  Future<void> previousPage(BuildContext context) async {
    if (_currentPage > 1) {
      _currentPage--;
      await fetchBlogs(context);
    }
  }
}
