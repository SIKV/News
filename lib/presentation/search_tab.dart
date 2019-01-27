import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/models/models.dart';
import 'package:news/presentation/article_card.dart';
import 'package:news/stores/news_store.dart';
import 'package:news/stores/saved_articles_store.dart';
import 'package:news/stores/search_history_store.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() {
    return new _SearchTabState();
  }
}

class _SearchTabState extends State<SearchTab> with StoreWatcherMixin<SearchTab> {
  NewsStore newsStore;
  SearchHistoryStore searchHistoryStore;
  SavedArticlesStore savedArticlesStore;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _searchTextFieldController = TextEditingController();

  bool _showClearIcon = false;
  bool _showSearchHistory = true;

  @override
  void initState() {
    super.initState();

    newsStore = listenToStore(newsStoreToken);
    searchHistoryStore = listenToStore(searchHistoryStoreToken);
    savedArticlesStore = listenToStore(savedArticlesStoreToken);

    loadSearchHistoryAction.call();
  }

  @override
  void dispose() {
    _searchTextFieldController.dispose();

    super.dispose();
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          text,
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
    );
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _showClearIcon = text.isNotEmpty;
    });
  }

  void _onSearchSubmitted(String text) {
    text = text.trim();

    if (text.isEmpty) {
      setState(() {
        _showSearchHistory = true;
      });
    } else {
      searchNewsAction.call(text);
      addSearchValueAction.call(text);

      setState(() {
        _showSearchHistory = false;
      });
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          elevation: 0.5,
          leading: Icon(
              CupertinoIcons.search,
              size: 28,
              color: Colors.black
          ),
          actions: <Widget>[
            _showClearIcon ? IconButton(
              icon: Icon(Icons.clear),
              iconSize: 24,
              color: Colors.grey,
              onPressed: _onClearButtonPressed,
            ) : Container(width: 0),
          ],
          title: TextField(
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
    return Text('Nothing Found');
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
                onSavePressed: () {
                  saveArticleAction.call(article).then((_) {
                    _showSnackBar(savedArticlesStore.saveActionStatus);
                  });
                },
                onSharePressed: () {
                  Share.share(article.url);
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