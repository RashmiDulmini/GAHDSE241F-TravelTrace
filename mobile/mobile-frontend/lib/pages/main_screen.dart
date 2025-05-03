import 'package:flutter/material.dart';
import 'package:traveltrace/pages/home_page.dart';
import 'package:traveltrace/pages/navbar.dart';
import 'package:traveltrace/pages/trail_create.dart';
import 'package:traveltrace/pages/trail_search.dart';
import 'package:traveltrace/pages/acc_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Pages for navigation
  final List<Widget> _pages = [
    HomePage(),            // Home Page
    TrailCreatePage(),     // Create Trail Page
    TrailSearchApp(),      // Search Trail Page
    AccountApp(),          // Profile Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
