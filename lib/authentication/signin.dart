import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Section with Background
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Hello!!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Profile Image
                    /*CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/animations/perTravel.json' // Replace with actual image
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),*/

                     // Lottie Animation
            Lottie.asset(
              'assets/animations/perTravel.json', // Ensure correct path
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Sign In Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Email Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.black),
                    hintText: "email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Password Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                    hintText: "password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sign In Button
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign-in logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // OR Login with
              Text(
                "OR login with",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 10),

/*
              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Facebook
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue, size: 30),
                    onPressed: () {
                      // Facebook login action
                    },
                  ),
                  SizedBox(width: 20),
                  // Google
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 30),
                    onPressed: () {
                      // Google login action
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              */
            ],
          ),
        ),
      ),
    );
  }
}
