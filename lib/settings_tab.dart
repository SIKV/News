import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news/models.dart';

class SettingsTab extends StatefulWidget {
  @override
  SettingsTabState createState() {
    return new SettingsTabState();
  }
}

class SettingsTabState extends State<SettingsTab> {
  Map<String, String> _countries = {};
  Map<String, String> _categories = {};

  List<DropdownMenuItem<String>> _countriesDropdownItems = [];
  List<DropdownMenuItem<String>> _categoriesDropdownItems = [];

  String _currentCountry;
  String _currentCategory;

  @override
  void initState() {
    _initCountries();
    _initCategories();

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

  void _initCountries() async {
    _countriesDropdownItems.add(new DropdownMenuItem(value: '', child: new Text('')));
    _currentCountry = '';

    await rootBundle.loadStructuredData<List<Map<String, dynamic>>>('countries.json', (jsonStr) async {
      var jsonDecoded = json.decode(jsonStr);

      _countries = {};

      jsonDecoded.forEach((v) {
        NameValue nameValue = NameValue.fromJson(v);
        _countries[nameValue.name] = nameValue.value;
      });
    });

    List<DropdownMenuItem<String>> items = new List();

    _countries.forEach((k, v) => items.add(
        new DropdownMenuItem(
            value: k,
            child: new Text(k)
        ))
    );

    _countriesDropdownItems = items;
    _currentCountry = _countriesDropdownItems[0].value;

    setState(() {});
  }

  void _initCategories() async {
    _categoriesDropdownItems.add(new DropdownMenuItem(value: '', child: new Text('')));
    _currentCategory = '';

    await rootBundle.loadStructuredData<List<Map<String, dynamic>>>('categories.json', (jsonStr) async {
      var jsonDecoded = json.decode(jsonStr);

      _categories = {};

      jsonDecoded.forEach((v) {
        NameValue nameValue = NameValue.fromJson(v);
        _categories[nameValue.name] = nameValue.value;
      });
    });

    List<DropdownMenuItem<String>> items = new List();

    _categories.forEach((k, v) => items.add(
        new DropdownMenuItem(
            value: k,
            child: new Text(k)
        ))
    );

    _categoriesDropdownItems = items;
    _currentCategory = _categoriesDropdownItems[0].value;

    setState(() {});
  }
}