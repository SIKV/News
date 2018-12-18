import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  @override
  SettingsTabState createState() {
    return new SettingsTabState();
  }
}

class SettingsTabState extends State<SettingsTab> {
  List _countries = ['All countries'];
  List _categories = ['All categories'];

  List<DropdownMenuItem<String>> _countriesDropdownItems;
  List<DropdownMenuItem<String>> _categoriesDropdownItems;

  String _currentCountry;
  String _currentCategory;

  @override
  void initState() {
    _countriesDropdownItems = _getCountriesDropdownItems();
    _categoriesDropdownItems = _getCategoriesDropdownItems();

    _currentCountry = _countriesDropdownItems[0].value;
    _currentCategory = _categoriesDropdownItems[0].value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Country',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: _currentCountry,
                      items: _countriesDropdownItems,
                      onChanged: (selectedValue) {
                        setState(() {
                          _currentCountry = selectedValue;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 24,
                  ),
                  Text(
                    'Category',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: _currentCategory,
                      items: _categoriesDropdownItems,
                      onChanged: (selectedValue) {
                        setState(() {
                          _currentCategory = selectedValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Powered by NewsAPI.org',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  List<DropdownMenuItem<String>> _getCountriesDropdownItems() {
    List<DropdownMenuItem<String>> items = new List();

    for (String city in _countries) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }

    return items;
  }

  List<DropdownMenuItem<String>> _getCategoriesDropdownItems() {
    List<DropdownMenuItem<String>> items = new List();

    for (String city in _categories) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }

    return items;
  }
}