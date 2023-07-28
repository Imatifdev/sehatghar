import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sehatghar/controller/utils/apiconstants.dart';
import 'dart:convert';

import '../../model/blogmodel.dart';

// A ChangeNotifier class for managing the list of blogs
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
        // Decode the response body from JSON format
        final jsonData = json.decode(response.body);

        // Map the JSON data to a list of Blog objects using the fromJson constructor
        _blogs = (jsonData['blogs'] as List)
            .map((item) => Blog.fromJson(item))
            .toList();

        // Notify listeners that the data has changed, so UI can be updated
        notifyListeners();
      } else {
        // Show a SnackBar with an error message if the API request fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to fetch the blogs Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Show a SnackBar with an error message if an exception occurs
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
