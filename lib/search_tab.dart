import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  SearchTabState createState() {
    return new SearchTabState();
  }
}

class SearchTabState extends State<SearchTab> {
  final _searchTextFieldController = TextEditingController();
  bool _showClearIcon = false;

  void _onSearchTextChanged(String text) {
    setState(() {
      _showClearIcon = text.isNotEmpty;
    });
  }

  void _onClearButtonPressed() {
    _searchTextFieldController.clear();
    _onSearchTextChanged('');
  }

  @override
  void dispose() {
    _searchTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
          leading: Icon(
              CupertinoIcons.search,
              size: 28,
              color: Colors.black
          ),
          trailing: _showClearIcon ? IconButton(
            icon: Icon(Icons.clear),
            iconSize: 24,
            color: Colors.grey,
            onPressed: _onClearButtonPressed,
          ) : Container(width: 0),
          middle: TextField(
            controller: _searchTextFieldController,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search'
            ),
            onChanged: _onSearchTextChanged
          )
      ),
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}