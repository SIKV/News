import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/news_tab.dart';
import 'package:news/search_tab.dart';
import 'package:news/settings_tab.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('News'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return NewsTab();
              },
              defaultTitle: 'News',
            );
            break;
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SearchTab();
              },
              defaultTitle: 'Search',
            );
            break;
          case 2:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SettingsTab();
              },
              defaultTitle: 'Settings',
            );
            break;
        }
        return null;
      },
    );
  }
}