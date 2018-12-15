import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:news/models.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  ArticleScreen({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: article.url,
      appBar: CupertinoNavigationBar(
          middle: Text(
            article.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
      ),
      withZoom: false,
    );
  }
}