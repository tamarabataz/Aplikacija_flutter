import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IKONICA KORISNIKA
            const Icon(
              Icons.person_outline,
              size: 80,
              color: Colors.brown,
            ),

            const SizedBox(height: 32),

            // IME
            TextField(
              decoration: InputDecoration(
                labelText: 'Ime',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 16),

            // EMAIL
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

            // LOZINKA
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

            // SIGN UP DUGME
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // kasnije: logika registracije
                },
                child: const Text('Sign up'),
              ),
            ),

            const SizedBox(height: 16),

            // LINK KA LOGINU
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Već imaš nalog? Login',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}