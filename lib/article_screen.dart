import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/models.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  ArticleScreen({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      child: Center(
        child: Text('Article'),
      ),
    );
  }
}