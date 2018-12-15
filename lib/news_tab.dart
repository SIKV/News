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
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.white),
      child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, i) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)
              ),
              margin: EdgeInsets.all(8.0),
              elevation: 0.5,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ArticleScreen(article: articles[i])
                      )
                  );
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)
                        ),
                        child: Image(
                          image: NetworkImage(articles[i].urlToImage),
                          fit: BoxFit.cover,
                          height: 175.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                        child: Text(
                          articles[i].getTitle(),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
                        child: Text(
                          articles[i].description,
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
                          '${articles[i].source.name} • ${articles[i].getPublishedAt()}',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                )
              )
          )
      ),
    );
  }
}