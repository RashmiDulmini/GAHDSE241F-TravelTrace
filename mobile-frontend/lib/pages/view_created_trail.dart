import 'package:flutter/material.dart';
import 'package:traveltrace/pages/navbar.dart';
import 'package:traveltrace/pages/trail_success.dart'; // Import trail_success.dart

void main() {
  runApp(ViewCreatedTrailApp());
}

class ViewCreatedTrailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewCreatedTrailScreen(),
    );
  }
}

class ViewCreatedTrailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Your Trail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to trail_success.dart
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TrailSuccessScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Header Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/trail_header.jpg', // Replace with actual image path
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),

              // Trail Cards in a Grid
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                children: [
                  buildTrailCard(
                    'assets/trail1.jpg', // Replace with actual image
                    'Description',
                    'Description Description',
                  ),
                  buildTrailCard(
                    'assets/trail2.jpg', // Replace with actual image
                    'Descriptions',
                    'Description',
                  ),
                  buildTrailCard(
                    'assets/trail3.jpg', // Replace with actual image
                    'Descriptions',
                    'Description',
                  ),
                  buildTrailCard(
                    'assets/trail4.jpg', // Replace with actual image
                    'More Info',
                    'Details about trail',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Navbar(
        selectedIndex: 2, // Assuming View Trail is at index 2
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

  Widget buildTrailCard(String imagePath, String title, String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
