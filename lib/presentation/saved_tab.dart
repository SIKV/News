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
        appBar: AppBar(
          title: Text('Saved'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: new Container()
    );
  }
}