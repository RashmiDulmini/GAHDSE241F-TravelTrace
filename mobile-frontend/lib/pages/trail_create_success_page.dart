import 'package:flutter/material.dart';

void main() {
  runApp(TrailCreatedSuccessApp());
}

class TrailCreatedSuccessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrailCreatedSuccessPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TrailCreatedSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text('Trail Created'),
        backgroundColor: Colors.cyan[700],
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Success Icon
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),

            // Success Message
            Text(
              'Your Trail Has Been Created Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),

            // Travel-Related Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage('assets/travel_image.jpg'), // <-- Add your travel image to assets folder
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30),

            // "View Your Trail" Button
            ElevatedButton(
              onPressed: () {
                // Navigate to your trail screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[700],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'View Your Trail',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
