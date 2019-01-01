import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/models/models.dart';
import 'package:news/presentation/article_card.dart';
import 'package:news/stores/news_store.dart';
import 'package:news/stores/search_history_store.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchTab extends StatefulWidget {
  @override
  SearchTabState createState() {
    return new SearchTabState();
  }
}

class SearchTabState extends State<SearchTab> with StoreWatcherMixin<SearchTab> {
  NewsStore newsStore;
  SearchHistoryStore searchHistoryStore;

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
    addSearchValueAction.call(text);

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

  void _onSearchValuePressed(String value) {
    _searchTextFieldController.text = value;

    _onSearchTextChanged(value);
    _onSearchSubmitted(value);
  }

  void _openArticle(Article article) async {
    if (await canLaunch(article.url)) {
      await launch(article.url);
    } else {
      throw 'Could not launch ${article.url}';
    }
  }

  @override
  void initState() {
    super.initState();

    newsStore = listenToStore(newsStoreToken);
    searchHistoryStore = listenToStore(searchHistoryStoreToken);

    loadSearchHistoryAction.call();
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
    return Center(
      child: newsStore.searchLoadingFirst ? CircularProgressIndicator()
          : newsStore.searchResultArticles.isEmpty ? _nothingFoundWidget() : _searchResultsList(),
    );
  }

  Widget _nothingFoundWidget() {
    return Text(
      'Nothing Found',
      style: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 22
      ),
    );
  }

  Widget _searchResultsList() {
    return Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: ListView.builder(
            itemCount: newsStore.searchResultArticles.length,
            itemBuilder: (context, i) {
              if (newsStore.searchResultHasMore && i == newsStore.searchResultArticles.length - 1) {
                searchMoreNewsAction.call();
              }

              Article article = newsStore.searchResultArticles[i];

              return ArticleCard(
                article: article,
                onPressed: () {
                  _openArticle(article);
                },
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
              itemCount: searchHistoryStore.searchHistory.length,
              itemBuilder: (context, i) {
                return _searchHistoryItemWidget(searchHistoryStore.searchHistory[i]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _searchHistoryItemWidget(String value) {
    return InkWell(
      onTap: () {
        _onSearchValuePressed(value);
      },
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
            child: Text(value)
          ),
        )
      ),
    );
  }
}