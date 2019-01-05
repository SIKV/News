import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() {
    return new _SavedTabState();
  }
}

class _SavedTabState extends State<SavedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Saved'),
        ),
        body: new Container()
    );
  }
}