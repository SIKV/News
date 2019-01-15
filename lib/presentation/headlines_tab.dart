import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/message_notifier.dart';
import 'package:news/presentation/news_tab.dart';

class HeadlinesTab extends StatefulWidget {
  @override
  _HeadlinesTabState createState() => _HeadlinesTabState();
}

class _HeadlinesTabState extends State<HeadlinesTab> with StoreWatcherMixin<HeadlinesTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    messageNotifier.listen((message) {
      showSnackBar(message);
    });
  }

  @override
  void dispose() {
    messageNotifier.dispose();

    super.dispose();
  }

  void showSnackBar(String text) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  title: Text('Headlines'),
                  pinned: true,
                  floating: true,
                  forceElevated: true,
                  elevation: 1.0,
                  centerTitle: true,
                  bottom: TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Business'),
                        Tab(text: 'Entertainment'),
                        Tab(text: 'General'),
                        Tab(text: 'Health'),
                        Tab(text: 'Science'),
                        Tab(text: 'Sports'),
                        Tab(text: 'Technology'),
                      ]
                  )
              )
            ];
          },
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: TabBarView(
              children: <Widget>[
                NewsTab(category: 'all'),
                NewsTab(category: 'business'),
                NewsTab(category: 'entertainment'),
                NewsTab(category: 'general'),
                NewsTab(category: 'health'),
                NewsTab(category: 'science'),
                NewsTab(category: 'sports'),
                NewsTab(category: 'technology'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}