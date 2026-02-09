import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class FilmListScreen extends StatefulWidget {
  const FilmListScreen({super.key});

  @override
  State<FilmListScreen> createState() => FilmListScreenState();
}

class FilmListScreenState extends State<FilmListScreen> {
  final List<Map<String, String>> films = [
    {
      'title': 'Ko to tamo peva',
      'image': 'assets/images/kototamopeva.jpg',
      'category': 'Kultni',
    },
    {
      'title': 'Maratonci trče počasni krug',
      'image': 'assets/images/maratonci.webp',
      'category': 'Komedija',
    },
    {
      'title': 'Balkanski špijun',
      'image': 'assets/images/balkanskispijun.jpg',
      'category': 'Drama',
    },
    {
      'title': 'Davitelj protiv davitelja',
      'image': 'assets/images/davitelj.jpg',
      'category': 'Kultni',
    },
    {
      'title': 'Sjećaš li se Dolly Bell?',
      'image': 'assets/images/dolly.jpg',
      'category': 'Drama',
    },
    {
      'title': 'Otac na službenom putu',
      'image': 'assets/images/Otac_na_sluzbenom_putu.jpg',
      'category': 'Drama',
    },
  ];

  final List<String> kategorije = [
    'Sve',
    'Kultni',
    'Komedija',
    'Drama',
  ];

  String izabranaKategorija = 'Sve';

  @override
  Widget build(BuildContext context) {
    final prikazaniFilmovi = izabranaKategorija == 'Sve'
        ? films
        : films
            .where((film) => film['category'] == izabranaKategorija)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmovi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Sign up',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButton<String>(
              value: izabranaKategorija,
              isExpanded: true,
              items: kategorije.map((kat) {
                return DropdownMenuItem(
                  value: kat,
                  child: Text(kat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  izabranaKategorija = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                itemCount: prikazaniFilmovi.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                itemBuilder: (context, index) {
                  final film = prikazaniFilmovi[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            film['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        film['title']!,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

