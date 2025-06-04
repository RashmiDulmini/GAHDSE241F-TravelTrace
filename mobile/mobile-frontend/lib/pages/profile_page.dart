import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveltrace/providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.jpg'), // You can make this dynamic
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              userProvider.fullName.isNotEmpty ? userProvider.fullName : 'Full Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(userProvider.userName.isNotEmpty ? '@${userProvider.userName}' : '@username'),
            SizedBox(height: 8),
            Text(userProvider.email.isNotEmpty ? userProvider.email : 'email@example.com'),
            SizedBox(height: 8),
            Text(userProvider.role.isNotEmpty ? 'Role: ${userProvider.role}' : 'Role: User'),
            SizedBox(height: 16),
            Divider(),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text(userProvider.address.isNotEmpty ? userProvider.address : 'Address not set'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(userProvider.contact.isNotEmpty ? userProvider.contact : 'Contact not set'),
            ),
          ],
        ),
      ),
    );
  }
}
