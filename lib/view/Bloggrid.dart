// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:sehatghar/controller/provider/blogprovider.dart';

import '../widgets/griditem.dart';

class BlogGridPage1 extends StatefulWidget {
  @override
  State<BlogGridPage1> createState() => _BlogGridPage1State();
}

class _BlogGridPage1State extends State<BlogGridPage1> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  // Load data in initState before loading into the main screen
  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  // Check whether the device is connected to the internet or not
  getConnectivity() => subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          showDialogBox();
          setState(() => isAlertSet = true);
        }
      });

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final blogModel = Provider.of<BlogModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          'Articles From Health Experts',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: FutureBuilder<void>(
        future: blogModel.fetchBlogs(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching blogs: ${snapshot.error}'),
            );
          } else {
            return Consumer<BlogModel>(
              builder: (context, model, _) {
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            childAspectRatio:
                                screenWidth > 400 ? 5 / 4 : 3 / 4),
                        itemCount: model.blogs.length,
                        itemBuilder: (context, index) {
                          return BlogGridItem(blog: model.blogs[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          _nextPage(context, blogModel);
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 2, color: Colors.green)),
                          child: Center(
                            child: Text(
                              "View More",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  // Method to fetch the previous page of blogs
  void _previousPage(BuildContext context, BlogModel model) {
    model.previousPage(context);
  }

  // Method to fetch the next page of blogs
  void _nextPage(BuildContext context, BlogModel model) {
    model.nextPage(context);
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && !isAlertSet) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
