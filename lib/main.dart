import 'package:flutter/material.dart';
//import 'package:traveltrace/authentication/getstarted.dart';
import 'package:traveltrace/pages/home_page.dart';
//import 'package:traveltrace/pages/acc_page.dart';
//import 'package:traveltrace/pages/acc_page.dart';
//import 'package:traveltrace/pages/trailsearch.dart';
//import 'package:traveltrace/pages/home_page.dart';

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
        body: HomePage(),
      ),
    );
  }
}
