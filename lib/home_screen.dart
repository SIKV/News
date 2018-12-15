import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/news_tab.dart';
import 'package:news/search_tab.dart';
import 'package:news/settings_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Theme.of(context).accentColor,
        backgroundColor: Colors.grey.shade100,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text(''),
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
            );
            break;
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SearchTab();
              },
            );
            break;
          case 2:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SettingsTab();
              },
            );
            break;
        }
        return null;
      },
    );
  }
}