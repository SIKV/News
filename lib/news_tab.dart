import 'package:flutter/cupertino.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: Center(
        child: Text("News"),
      ),
    );
  }
}