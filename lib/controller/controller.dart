import 'package:flutter/material.dart';
import 'package:sehatghar/controller/provider/blogprovider.dart';

class BlogController {
  final BlogModel _model;

  BlogController(this._model);

  Future<void> fetchBlogs(BuildContext context) async {
    await _model.fetchBlogs(context);
  }
}
