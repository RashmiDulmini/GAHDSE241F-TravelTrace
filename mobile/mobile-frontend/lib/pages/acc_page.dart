import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveltrace/pages/navbar.dart';
import 'package:traveltrace/pages/trail_create.dart';
import 'package:traveltrace/pages/trail_search.dart';
import 'package:traveltrace/pages/home_page.dart';
import 'package:traveltrace/pages/edit_profile.dart';
import 'package:traveltrace/pages/password_change.dart';
import 'package:traveltrace/providers/user_provider.dart';

class AccountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.cyan[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.account_box, size: 100, color: Colors.black),
            SizedBox(height: 8.0),
            Text(
              userProvider.userName.isNotEmpty
                  ? userProvider.userName
                  : 'Guest User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'User ID: ${userProvider.userId.isNotEmpty ? userProvider.userId : 'N/A'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 24.0),

            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileUpdateApp()),
                );
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PasswordChangeScreen()),
                );
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Handle notifications tap
              },
            ),

            Spacer(),

            ElevatedButton(
              onPressed: () {
                userProvider.clearUser(); // Clear on logout
                // Navigate to login screen or splash
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

      bottomNavigationBar: Navbar(
        selectedIndex: 3,
        onItemTapped: (index) {
          Widget destination;
          switch (index) {
            case 0:
              destination = HomePage();
              break;
            case 1:
              destination = TrailCreatePage();
              break;
            case 2:
              destination = TrailSearchScreen();
              break;
            case 3:
            default:
              destination = AccountApp();
              break;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    );
  }
}
