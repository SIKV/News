import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/models/models.dart';
import 'package:news/presentation/article_card.dart';
import 'package:news/stores/search_store.dart';

class SearchTab extends StatefulWidget {
  @override
  SearchTabState createState() {
    return new SearchTabState();
  }
}

class SearchTabState extends State<SearchTab> with StoreWatcherMixin<SearchTab> {
  SearchStore searchStore;

  final _searchTextFieldController = TextEditingController();

  bool _showClearIcon = false;
  bool _showSearchHistory = true;

  void _onSearchTextChanged(String text) {
    setState(() {
      _showClearIcon = text.isNotEmpty;
    });
  }

  void _onSearchSubmitted(String text) {
    searchNewsAction.call(text);

    setState(() {
      _showSearchHistory = false;
    });
  }

  void _onClearButtonPressed() {
    _searchTextFieldController.clear();

    setState(() {
      _showClearIcon = false;
      _showSearchHistory = true;
    });
  }

  @override
  void initState() {
    super.initState();

    searchStore = listenToStore(searchStoreToken);
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
            textInputAction: TextInputAction.search,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search'
            ),
            onSubmitted: _onSearchSubmitted,
            onChanged: _onSearchTextChanged
          )
      ),
      body: Stack(
        children: <Widget>[
          _showSearchHistory ? _searchHistoryList() : _searchWidget()
        ],
      ),
    );
  }

  Widget _searchWidget() {
    return Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: ListView.builder(
            itemCount: searchStore.articles.length,
            itemBuilder: (context, i) {
              Article article = searchStore.articles[i];
              return ArticleCard(
                article: article,
                onPressed: () { },
              );
            }
        )
    );
  }

  Widget _searchHistoryList() {
    return Padding(
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