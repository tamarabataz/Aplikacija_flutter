import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'film_list_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 70,
              color: Colors.brown,
            ),
            const SizedBox(height: 24),

            // Email
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 16),

            // Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Lozinka',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 24),

            // Login dugme
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // za sada samo ulaz
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FilmListScreen(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ),

            const SizedBox(height: 16),

            // Sign up link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(),
                  ),
                );
              },
              child: const Text('Nemam nalog? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}