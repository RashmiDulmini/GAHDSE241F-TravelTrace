import 'package:flutter/material.dart';
import 'trail_create.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Trace'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Section
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/your-banner-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Explore the World with Travel Trace',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            
            // Featured Destinations Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Featured Destinations',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4, // Number of featured destinations
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Image.asset('assets/destination${index + 1}.jpg', height: 120, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Destination ${index + 1}', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            // Recent Updates Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Recent Updates',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text('Latest travel blog or update title'),
              subtitle: Text('A brief description or excerpt from the blog or update'),
              onTap: () {
                // Navigate to the full update/blog page
              },
            ),
            
            // About Us Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'About Travel Trace',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Travel Trace helps you explore the world, find amazing destinations, and stay updated with the latest travel news.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            
            // Popular Trails Section with Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Popular Trails',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrailCreatePage()),
                      );
                    },
                    child: Text('Create a Trail'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Footer (optional)
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.facebook), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
