import 'package:flutter/material.dart';
import 'package:traveltrace/pages/acc_page.dart';
import 'package:traveltrace/pages/home_page.dart';
import 'package:traveltrace/pages/navbar.dart';
import 'package:traveltrace/pages/trail_create.dart';
import 'package:traveltrace/pages/navbar.dart';

void main() {
  runApp(TrailSearchApp());
}

class TrailSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrailSearchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TrailSearchScreen extends StatefulWidget {
  @override
  _TrailSearchScreenState createState() => _TrailSearchScreenState();
}

class _TrailSearchScreenState extends State<TrailSearchScreen> {
  String selected = '';
  String trailName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trail Search'),
        backgroundColor: Colors.cyan[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Section
            Text('Selected'),
            SizedBox(height: 10),

            // Trail Name Search
            TextField(
              decoration: InputDecoration(
                labelText: 'Trail Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  trailName = value;
                });
              },
            ),

            SizedBox(height: 16.0),

            // Search Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Search logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[700],
                ),
                child: Text('Search Trail'),
              ),
            ),

            SizedBox(height: 20.0),

            // Trail Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e', // replace with your image url or asset
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Sunset by the beach trail. Enjoy the view and relax.\n\nFor personalized recommendations, try our AI trip-planning provider.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Latest Search Section
            Text(
              'Latest Search',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // GridView for latest search (wrapped in fixed height container)
            Container(
              height: 200,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6, // You can change the count
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, size: 40, color: Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Navbar(
        selectedIndex: 2, // Setting this as the third page in navigation (Search)
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
                    return AccountApp();
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
