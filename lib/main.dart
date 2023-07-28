import 'package:flutter/material.dart';
import 'package:sehatghar/view/bloggrid.dart';

import 'controller/provider/blogprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BlogModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlogGridPage1(),
    );
  }
}
