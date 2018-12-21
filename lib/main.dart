import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news/home_screen.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.grey.shade200,
    ));

    return new MaterialApp(
      title: 'News',
      theme: ThemeData(
        accentColor: Colors.black
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}