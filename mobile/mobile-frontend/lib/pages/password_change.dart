import 'package:flutter/material.dart';
import 'package:traveltrace/pages/acc_page.dart';
import 'package:traveltrace/pages/navbar.dart';

void main() {
  runApp(PasswordChangeApp());
}

class PasswordChangeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PasswordChangeScreen(),
    );
  }
}

class PasswordChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF23A7F1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccountApp()),
            );
          },
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Password Form Container
            Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 60),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  _buildTextField("Current Password"),
                  _buildTextField("New Password"),
                  _buildTextField("Confirm Password"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle password change logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Positioned Key Icon
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.vpn_key, size: 40, color: Colors.indigo),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Navbar(
        selectedIndex: 3,
        onItemTapped: (index) {
          Navigator.pushReplacementNamed(
            context,
            index == 0 ? '/home' :
            index == 1 ? '/trail_create' :
            index == 2 ? '/trail_search' :
            '/account',
          );
        },
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
