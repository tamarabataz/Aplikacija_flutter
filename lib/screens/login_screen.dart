import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'film_list_screen.dart';
import 'package:film_app/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 70, color: Colors.brown),
              const SizedBox(height: 24),

              // EMAIL
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email je obavezan';
                  }
                  if (!value.contains('@')) {
                    return 'Email nije validan';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // PASSWORD
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Lozinka',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lozinka je obavezna';
                  }
                  if (value.length < 4) {
                    return 'Lozinka mora imati bar 4 karaktera';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // LOGIN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    final email = emailController.text;
                    final password = passwordController.text;

                    // PROVERA DA LI POSTOJI NALOG
                    if (AuthService.users.containsKey(email) &&
    AuthService.users[email] == password) {
  AuthService.isLoggedIn = true;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const FilmListScreen(),
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Ne postoji nalog ili je lozinka pogrešna'),
    ),
  );
}
                  },
                  child: const Text('Login'),
                ),
              ),

              const SizedBox(height: 16),

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
      ),
    );
  }
}