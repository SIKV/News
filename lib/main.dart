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
      statusBarColor: Colors.white.withAlpha(500),
    ));

    return new MaterialApp(
      title: 'News',
      theme: ThemeData(
        accentColor: Colors.blueAccent
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}