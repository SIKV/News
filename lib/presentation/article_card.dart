import 'package:flutter/material.dart';
import 'package:news/models/models.dart';
import 'package:news/utils.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onPressed;

  ArticleCard({this.article, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        margin: EdgeInsets.all(8),
        elevation: 0.5,
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onPressed();
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
          child: article.hasImage() ? Image(
            image: NetworkImage(article.urlToImage),
            fit: BoxFit.cover,
            height: 175,
          ) : Container(
            height: 175,
            color: Colors.grey.shade300,
            child: Center(
              child: Text(
                'No image',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade200
                ),
              ),
            ),
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
            '${article.source.name} • ${formatDate(article.publishedAt)}',
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