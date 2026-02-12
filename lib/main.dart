import 'package:film_app/screens/root_screen.dart';
import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/providers/wishlist_provider.dart';

void main() {
  runApp(const FilmApp());
}

class FilmApp extends StatelessWidget {
  const FilmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => FilmsProvider()),
     ChangeNotifierProvider(create: (_) => WishlistProvider()),
  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'FilmApp',
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
    home: const AuthScreen(),
  ),
);
  }
}




 