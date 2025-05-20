import 'package:flutter/material.dart';
import 'package:traveltrace/authentication/getstarted.dart';
import 'package:traveltrace/pages/home_page.dart'; // <-- Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'get',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GetStartedPage(),
      ),
      routes: {
        '/home': (context) => HomePage(), // <-- Add this route
      },
    );
  }
}
