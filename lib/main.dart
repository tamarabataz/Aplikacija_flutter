import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';


void main() {
  runApp(const FilmApp());
}

class FilmApp extends StatelessWidget {
  const FilmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FilmApp',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home:  AuthScreen(),
    );
  }
}




 