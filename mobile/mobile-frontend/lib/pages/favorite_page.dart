import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data – you can replace this with real backend data
    final List<Map<String, String>> favoriteTrails = [
      {
        'title': 'Ella Hiking Trail',
        'location': 'Ella, Sri Lanka',
        'image': 'assets/trail1.jpg',
      },
      {
        'title': 'Sigiriya Rock View',
        'location': 'Sigiriya, Sri Lanka',
        'image': 'assets/trail2.jpg',
      },
      {
        'title': 'Mirissa Beach Walk',
        'location': 'Mirissa, Sri Lanka',
        'image': 'assets/trail3.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Trails'),
        backgroundColor: Colors.blue,
      ),
      body: favoriteTrails.isEmpty
          ? Center(
              child: Text(
                'No favorite trails yet.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: favoriteTrails.length,
              itemBuilder: (context, index) {
                final trail = favoriteTrails[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        trail['image']!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(trail['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(trail['location']!),
                    trailing: Icon(Icons.favorite, color: Colors.red),
                    onTap: () {
                      // TODO: Navigate to full trail detail page
                    },
                  ),
                );
              },
            ),
    );
  }
}
