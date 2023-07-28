// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../model/blogmodel.dart';
import '../view/blogdetail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class BlogGridItem extends StatefulWidget {
  final Blog blog;

  BlogGridItem({required this.blog});

  @override
  State<BlogGridItem> createState() => _BlogGridItemState();
}

class _BlogGridItemState extends State<BlogGridItem> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

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
        screenWidth * 0.034 * MediaQuery.of(context).textScaleFactor;
    final heading =
        screenWidth * 0.039 * MediaQuery.of(context).textScaleFactor;
    final radius = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailsPage(blog: widget.blog),
          ),
        );
      },
      child: Container(
        height: screenHeight,
        width: screenWidth / 1.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              // Display a placeholder image if there's an error loading the image
              CachedNetworkImage(
                height: screenWidth > 550 ? screenHeight / 5 : screenHeight / 7,
                width: screenWidth / 1.4,
                fit: BoxFit.cover,
                imageUrl: widget.blog.image,
                placeholder: (context, url) =>
                    Placeholder(), // Optional placeholder widget while loading
                errorWidget: (context, url, error) => Icon(Icons
                    .error), // Optional error widget if image fails to load
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _getFewWordsFromTitle(widget.blog.routeTitle),
                      overflow: TextOverflow.ellipsis,
                      maxLines: screenWidth > 700 ? 3 : 2,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: heading, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          child: Icon(
                            CupertinoIcons.person,
                            size: 10,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        widget.blog.agentId.firstName == ''
                            ? Text(
                                'unknown | ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: subheading),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFewWordsFromTitle(String title) {
    // Define the number of words to show (e.g., 5 words)
    int maxWords = 5;

    // Split the title into words
    List<String> words = title.split(' ');

    // Take only the first few words (up to maxWords) and join them back
    String shortenedTitle = words.take(maxWords).join(' ');

    return shortenedTitle;
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
                if (!isDeviceConnected && isAlertSet == false) {
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
