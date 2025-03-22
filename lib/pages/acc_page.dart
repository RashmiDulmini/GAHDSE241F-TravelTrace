import 'package:flutter/material.dart';
import 'package:traveltrace/pages/home_page.dart';
import 'package:traveltrace/pages/navbar.dart';
import 'package:traveltrace/pages/trail_create.dart';
import 'package:traveltrace/pages/trail_search.dart';
import 'package:traveltrace/pages/navbar.dart';

void main() {
  runApp(AccountApp());
}

class AccountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AccountScreen extends StatelessWidget {
  final String userName = 'Jack';
  final String userId = 'ID0148527';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.cyan[700],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu icon press
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Icon
            Icon(
              Icons.account_box,
              size: 100,
              color: Colors.black,
            ),
            SizedBox(height: 8.0),

            // Username and ID
            Text(
              userName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'User ID: $userId',
              style: TextStyle(color: Colors.grey[600]),
            ),

            SizedBox(height: 24.0),

            // Edit Profile Button
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                // Handle edit profile tap
              },
            ),
            Divider(),

            // Change Password Button
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                // Handle change password tap
              },
            ),
            Divider(),

            // Notifications Button
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Handle notifications tap
              },
            ),

            Spacer(),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Handle logout logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[700],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Navbar(
        selectedIndex: 3, // Setting this as the fourth page in navigation (Account)
        onItemTapped: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                switch (index) {
                  case 0:
                    return HomePage();
                  case 1:
                    return TrailCreatePage();
                  case 2:
                    return TrailSearchScreen();
                  case 3:
                    return AccountScreen();
                  default:
                    return HomePage();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
