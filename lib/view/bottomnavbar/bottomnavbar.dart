import 'package:flutter/material.dart';
import 'package:vipc_app/view/notifications/notifications_view.dart';
import 'package:vipc_app/view/search/search_view.dart';
import 'package:vipc_app/view/home/home_view.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:vipc_app/view/settings/settings_view.dart';
import 'package:vipc_app/view/monitor/monitor_view.dart';
import 'package:vipc_app/view/news/news_view.dart';

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  CustomNavBar({Key key})
      : preferredSize = Size.fromHeight(56),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    ProspectView(),
    MonitorView(),
    NewsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Center(child: _widgetOptions.elementAt(_selectedIndex));
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Prospect',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervisor_account),
          label: 'Monitor',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.my_library_books),
          label: 'News',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber,
      onTap: _onItemTapped,
    );
  }
}
