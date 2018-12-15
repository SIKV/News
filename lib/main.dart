import 'package:flutter/cupertino.dart';
import 'package:news/home_screen.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CupertinoApp(
      title: 'News',
      home: HomeScreen()
    );
  }
}