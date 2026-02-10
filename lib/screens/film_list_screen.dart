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
      backgroundColor: const Color(0xFFD6AE7B), // glavna pozadina
      appBar: AppBar(
        title: const Text('Filmovi'),
        backgroundColor: const Color(0xFFB6895A), // tamniji header
        elevation: 0,
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
            // FILTER KATEGORIJA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFB6895A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: izabranaKategorija,
                  isExpanded: true,
                  dropdownColor: const Color(0xFFD6AE7B),
                  items: kategorije.map((kat) {
                    return DropdownMenuItem(
                      value: kat,
                      child: Text(
                        kat,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      izabranaKategorija = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // GRID FILMOVA
            Expanded(
              child: GridView.builder(
                itemCount: prikazaniFilmovi.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  final film = prikazaniFilmovi[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7C59A),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.asset(
                              film['image']!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            film['title']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
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

