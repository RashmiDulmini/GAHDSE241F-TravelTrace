import 'package:flutter/material.dart';
import 'package:traveltrace/pages/navbar.dart';
import 'package:traveltrace/pages/acc_page.dart'; // Importing Account Page

void main() {
  runApp(ProfileUpdateApp());
}

class ProfileUpdateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileUpdateScreen(),
    );
  }
}

class ProfileUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Your Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to Account Page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual image path
              ),
              SizedBox(height: 20),

              // Input Fields
              _buildTextField("Full Name"),
              _buildTextField("User Name"),
              _buildTextField("Address"),
              _buildTextField("Contact Number"),
              _buildTextField("Email"),
              _buildTextField("Password"),

              SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Handle save logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar with Navbar widget
      bottomNavigationBar: Navbar(
        selectedIndex: 3, // Assuming 3rd index is for Account/Profile
        onItemTapped: (index) {
          Navigator.pushReplacementNamed(
            context,
            index == 0 ? '/home' :
            index == 1 ? '/trail_create' :
            index == 2 ? '/trail_search' :
            '/account', // Default to account page
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
