import 'package:film_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/providers/wishlist_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  textTheme: GoogleFonts.poppinsTextTheme(),
),
    home: const LoginScreen(),
  ),
);
  }
}




 
