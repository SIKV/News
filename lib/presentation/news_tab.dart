import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/models/models.dart';
import 'package:news/presentation/article_card.dart';
import 'package:news/stores/news_store.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with StoreWatcherMixin<NewsTab> {
  NewsStore newsStore;

  @override
  void initState() {
    super.initState();

    newsStore = listenToStore(newsStoreToken);

    loadNewsAction.call();
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
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: newsStore.loadingFirst ? CircularProgressIndicator() : _articlesList()
      )
    );
  }

  Widget _articlesList() {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.white),
      child: ListView.builder(
        itemCount: newsStore.articles.length,
        itemBuilder: (context, i) {
          if (newsStore.hasMore && i == newsStore.articles.length - 1) {
            loadMoreNewsAction.call();
          }

          Article article = newsStore.articles[i];

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