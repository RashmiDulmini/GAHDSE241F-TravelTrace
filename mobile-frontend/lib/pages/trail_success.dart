import 'package:flutter/material.dart';
import 'package:traveltrace/pages/view_created_trail.dart'; // Import the target page

void main() {
  runApp(TrailSuccessScreen());
}

class TrailSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF23A7F1),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Navigates back to the previous page
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trail created successfully!!!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1B75),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                
                // View Your Trail Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to ViewCreatedTrailScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ViewCreatedTrailScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDADADA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'View your trail ➜',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Trail Image
                Image.asset(
                  'assets/travel.png', // Ensure correct path
                  height: 250,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
