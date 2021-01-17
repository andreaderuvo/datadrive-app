import 'package:flutter/material.dart';
import 'package:obd/pages/transactions_page.dart';
import 'package:provider/provider.dart';
import 'package:obd/bottom_navigation_provider.dart';
import 'package:obd/pages/blank_page.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentTab = [
    BlankPage(
      icon: Icon(Icons.directions_car),
      title: 'Dashboard',
    ),
    TransactionsPage(
      title: 'Transactions',
    ),
    BlankPage(
      icon: Icon(Icons.settings),
      title: 'Settings',
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationProvider>(context);
    return Scaffold(
      body: currentTab[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
        },
        iconSize: 30,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.directions_car),
            title: new Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.linear_scale),
            title: new Text('Transactions'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            title: new Text('Settings'),
          )
        ],
      ),
    );
  }
}
