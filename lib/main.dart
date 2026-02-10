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
    scaffoldBackgroundColor: const Color.fromARGB(255, 211, 165, 112),
    appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFB6895A),
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  ),
  home: const AuthScreen(),
);
  }
}




 