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
  bool _showSearchHistory = true;

  void _onSearchTextChanged(String text) {
    setState(() {
      _showClearIcon = text.isNotEmpty;
      _showSearchHistory = text.isEmpty;
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
      body: Stack(
        children: <Widget>[
          _showSearchHistory ? Padding(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Search History',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800
                  ),
                ),
                Container(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, i) {
                      return _searchHistoryItemWidget();
                    },
                  ),
                )
              ],
            ),
          ) : Container()
        ],
      ),
    );
  }

  Widget _searchHistoryItemWidget() {
    return InkWell(
      onTap: () { },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
            )
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Text')
          ),
        )
      ),
    );
  }
}