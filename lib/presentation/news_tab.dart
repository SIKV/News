import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/models/models.dart';
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
          return _articleCard(newsStore.articles[i]);
        }
      )
    );
  }

  Widget _articleCard(Article article) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        margin: EdgeInsets.all(8),
        elevation: 0.5,
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              _openArticle(article);
            },
            child: Container(
                child: _articleWidget(article)
            )
        )
    );
  }

  Widget _articleWidget(Article article) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16)
          ),
          child: Image(
            image: NetworkImage(article.urlToImage),
            fit: BoxFit.cover,
            height: 175,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Text(
            article.getTitle(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, top: 8, right: 16),
          child: Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
          child: Text(
            '${article.source.name} • ${article.getPublishedAt()}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}