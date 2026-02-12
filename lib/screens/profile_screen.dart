import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_app/auth_service.dart';
import 'package:film_app/screens/login_screen.dart';
import 'package:film_app/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = FirebaseAuth.instance.currentUser == null
        ? Future.value(null)
        : _loadUserDocument();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _loadUserDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }

  void _refreshUserData() {
    setState(() {
      _userFuture = FirebaseAuth.instance.currentUser == null
          ? Future.value(null)
          : _loadUserDocument();
    });
  }

  Future<void> _showEditProfileDialog(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final nameController = TextEditingController(
      text: (data['name'] ?? '').toString(),
    );
    final emailController = TextEditingController(
      text: (user.email ?? '').toString(),
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Izmeni profil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Ime"),
              ),
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = user.email;
                if (email == null || email.isEmpty) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email nije dostupan.")),
                  );
                  return;
                }

                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Link za promenu lozinke je poslat na vaš email.",
                      ),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.message ?? "Greška pri slanju linka za promenu lozinke.",
                      ),
                    ),
                  );
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Greška pri slanju linka za promenu lozinke."),
                    ),
                  );
                }
              },
              child: const Text("Promeni lozinku"),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Otkaži"),
            ),
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();

                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                    'name': newName,
                  });

                  if (!mounted) return;
                  Navigator.of(dialogContext).pop();
                  _refreshUserData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ime uspešno ažurirano")),
                  );
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? "Greška pri ažuriranju profila."),
                    ),
                  );
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Greška pri ažuriranju profila."),
                    ),
                  );
                }
              },
              child: const Text("Sačuvaj"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = FirebaseAuth.instance.currentUser == null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 110, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "👤 Moj profil",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                if (isGuest)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Da biste mogli da vidite ili izmenite svoj profil, morate da se prijavite.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text("Sign up"),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                              child: const Text("Log in"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                    future: _userFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data?.data() ?? <String, dynamic>{};
                      final name = data['name'] ?? '';
                      final email = data['email'] ?? '';
                      final role = data['role'] ?? '';

                      return Column(
                        children: [
                          _buildInfoTile("Ime", name.toString()),
                          const SizedBox(height: 15),
                          _buildInfoTile("Email", email.toString()),
                          const SizedBox(height: 15),
                          _buildInfoTile("Uloga", role.toString()),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  if (AuthService.isLoggedIn)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE7C59A),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final snapshot = await _userFuture;
                          final data = snapshot?.data() ?? <String, dynamic>{};
                          if (!mounted) return;
                          await _showEditProfileDialog(data);
                        },
                        child: const Text("Izmeni profil"),
                      ),
                    ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    onPressed: () async {
                      await AuthService.instance.logout();
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                      child: const Text("Odjava"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
