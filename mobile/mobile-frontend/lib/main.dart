import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveltrace/authentication/getstarted.dart';
import 'package:traveltrace/authentication/signin.dart';   // Assuming you have this
import 'package:traveltrace/pages/main_screen.dart';
import 'package:traveltrace/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TravelTrace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/getstarted',  // Start at GetStartedPage
      routes: {
        '/getstarted': (context) => GetStartedPage(),
        '/signin': (context) => SignInPage(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
