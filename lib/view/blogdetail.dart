import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../model/blogmodel.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class BlogDetailsPage extends StatefulWidget {
  final Blog blog;

  BlogDetailsPage({required this.blog});

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
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
    final subheading =
        screenWidth * 0.045 * MediaQuery.of(context).textScaleFactor;
    final heading =
        screenWidth * 0.069 * MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.left_chevron)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                height: screenHeight / 3,
                width: screenWidth,
                fit: BoxFit.cover,
                imageUrl: widget.blog.image,
                placeholder: (context, url) =>
                    Placeholder(), // Optional placeholder widget while loading
                errorWidget: (context, url, error) => Icon(Icons
                    .error), // Optional error widget if image fails to load
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blog.title,
                      style: TextStyle(
                        fontSize: heading,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: Icon(
                            CupertinoIcons.person,
                            size: 20,
                          ),
                        ),
                        Divider(),
                        SizedBox(width: screenWidth * 0.01),
                        widget.blog.agentId.firstName == ''
                            ? Text(
                                'unknown | ',
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                '${widget.blog.agentId.firstName} | ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: subheading),
                              ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '${widget.blog.createdAt.day.toString()}-${widget.blog.createdAt.month.toString()}-${widget.blog.createdAt.year.toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: subheading),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    HtmlWidget(
                      widget.blog.content,
                      textStyle: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
