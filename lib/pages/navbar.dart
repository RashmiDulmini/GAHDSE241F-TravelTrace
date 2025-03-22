import 'package:flutter/material.dart';
import 'package:traveltrace/pages/home_page.dart';
import 'package:traveltrace/pages/trail_create.dart';
import 'package:traveltrace/pages/trail_search.dart';
import 'package:traveltrace/pages/acc_page.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  Navbar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index != selectedIndex) {
          Widget nextPage;
          switch (index) {
            case 0:
              nextPage = HomePage();
              break;
            case 1:
              nextPage = TrailCreatePage();
              break;
            case 2:
              nextPage = TrailSearchApp();
              break;
            case 3:
              nextPage = AccountApp();
              break;
            default:
              return;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
