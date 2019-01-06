import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/models/models.dart';
import 'package:news/presentation/article_card.dart';
import 'package:news/stores/news_store.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTab extends StatefulWidget {
  final String category;

  NewsTab({Key key, this.category});

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with StoreWatcherMixin<NewsTab> {
  NewsStore newsStore;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    newsStore = listenToStore(newsStoreToken);

    loadNewsAction.call(widget.category);

    super.initState();
  }

  void _openArticle(Article article) async {
    if (await canLaunch(article.url)) {
      await launch(article.url);
    } else {
      throw 'Could not launch ${article.url}';
    }
  }

  Future<Null> _refresh() {
    return reloadNewsAction.call(widget.category).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: newsStore.getCategory(widget.category).loadingFirst ? CircularProgressIndicator() : _articlesWidget()
    );
  }

  Widget _articlesWidget() {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: newsStore.getCategory(widget.category).hasError ? SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: Text(newsStore.getCategory(widget.category).error))
            )
        ) : _articlesList()
    );
  }

  Widget _articlesList() {
    return Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: ListView.builder(
            itemCount: newsStore.getCategory(widget.category).articles.length,
            itemBuilder: (context, i) {
              if (newsStore.getCategory(widget.category).hasMore
                  && i == newsStore.getCategory(widget.category).articles.length - 1) {
                loadMoreNewsAction.call(widget.category);
              }

              Article article = newsStore.getCategory(widget.category).articles[i];

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
}