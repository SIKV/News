import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/api.dart';
import 'package:news/article_screen.dart';
import 'package:news/models.dart';

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: FutureBuilder(
          future: Api.internal().fetchArticles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return articlesList(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget articlesList(List<Article> articles) {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, i) => Card(
            margin: EdgeInsets.all(8.0),
            elevation: 2.0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ArticleScreen(article: articles[i])
                  )
                );
              },
              child: Stack(
                  children: <Widget>[
                    Image(
                      image: NetworkImage(articles[i].urlToImage),
                      fit: BoxFit.cover,
                      height: 250.0,
                    ),
                    Positioned(
                      child: Container(
                        child: Text(
                            articles[i].title,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w900
                            )
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black.withAlpha(150)
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                    ),
                  ]
              ),
            )
        )
    );
  }
}