import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/api.dart';
import 'package:news/models.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<Article> _articles = [];
  int _page = 0;

  bool _loadingFirst = true;
  bool _loadingMore = false;

  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    _lockedLoadMore();
  }

  void _openArticle(Article article) async {
    if (await canLaunch(article.url)) {
      await launch(article.url);
    } else {
      throw 'Could not launch ${article.url}';
    }
  }

  Future _loadMore() async {
    _page++;
    List<Article> articles = await Api.internal().fetchArticles(_page);

    if (mounted) {
      setState(() {
        _loadingFirst = false;

        _hasMore = articles.isNotEmpty;
        _articles.addAll(articles);
      });
    }
  }

  void _lockedLoadMore() {
    if (!_loadingMore) {
      _loadingMore = true;

      _loadMore().then((_) {
        _loadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: _loadingFirst ? CircularProgressIndicator() : _articlesList()
      )
    );
  }

  Widget _articlesList() {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.white),
      child: ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, i) {
          if (_hasMore && i == _articles.length - 1) {
            _lockedLoadMore();
          }
          return _articleCard(_articles[i]);
        }
      )
    );
  }

  Widget _articleCard(Article article) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        margin: EdgeInsets.all(8.0),
        elevation: 0.5,
        child: InkWell(
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
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0)
          ),
          child: Image(
            image: NetworkImage(article.urlToImage),
            fit: BoxFit.cover,
            height: 175.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Text(
            article.getTitle(),
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
          child: Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
          child: Text(
            '${article.source.name} • ${article.getPublishedAt()}',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}