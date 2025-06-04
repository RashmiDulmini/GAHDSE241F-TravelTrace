import 'package:flutter/material.dart';

class MyTrailsPage extends StatelessWidget {
  final List<Map<String, String>> sampleTrails = [
    {'title': 'Trip to Ella', 'description': 'Hiking and scenic views'},
    {'title': 'Nuwara Eliya Visit', 'description': 'Tea plantations and cold weather'},
    {'title': 'Colombo City Tour', 'description': 'Culture and food exploration'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Trails'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: sampleTrails.length,
        itemBuilder: (context, index) {
          final trail = sampleTrails[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.terrain, color: Colors.blue),
              title: Text(trail['title']!),
              subtitle: Text(trail['description']!),
              onTap: () {
                // TODO: Navigate to trail details
              },
            ),
          );
        },
      ),
    );
  }
}
