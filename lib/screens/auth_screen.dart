import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'film_list_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Naslov
              const Text(
                'Dobrodošli',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // "Logo" (za sad ikonica, kasnije može prava slika)
              const Icon(
                Icons.movie,
                size: 80,
                color: Colors.brown,
              ),

              const SizedBox(height: 40),

              // LOGIN dugme
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Login'),
                ),
              ),

              const SizedBox(height: 12),

              // SIGN UP dugme
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ),
              const SizedBox(height: 24),


              TextButton(
              onPressed: () {
               Navigator.pushReplacement(
                context,
              MaterialPageRoute(
                 builder: (_) =>  FilmListScreen(),
              ),
           );
          },
          child: const Text(
              'Nastavi kao gost',
              style: TextStyle(
               fontSize: 16,
              decoration: TextDecoration.underline,
              ),
            ),
          ),





            ],
            






          ),
        ),
      ),
    );
  }
}