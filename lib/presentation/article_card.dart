import 'package:flutter/material.dart';
import 'package:news/models/models.dart';
import 'package:news/utils.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  final VoidCallback onPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onSharePressed;

  ArticleCard({this.article, this.onPressed, this.onSavePressed, this.onSharePressed});

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
                child: _articleWidget(context, article)
            )
        )
    );
  }

  Widget _articleWidget(BuildContext context, Article article) {
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
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.w500
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
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${article.source.name} • ${formatDate(article.publishedAt)}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_horiz, color: Colors.black54),
                onPressed: () {
                  _showOptionsBottomSheet(context, article);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  void _showOptionsBottomSheet(BuildContext context, Article article) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.star_border),
                  title: Text('Save for later'),
                  onTap: () {
                    onSavePressed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  onTap: () {
                    onSharePressed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Cancel'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
    );
  }
}