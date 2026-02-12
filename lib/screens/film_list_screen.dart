import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'film_detail_screen.dart';
import 'package:film_app/auth_service.dart';
import 'package:film_app/admin/admin_dashboard_screen.dart';
import 'search_screen.dart';

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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Filmovi",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [

          if (AuthService.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDashboardScreen(),
                  ),
                );
              },
            ),

          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),

          IconButton(
  icon: const Icon(Icons.login),
  onPressed: () {
    AuthService.logout(); // ← ODJAVA ADMINA

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  },
),

          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              AuthService.logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [

          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 110, left: 16, right: 16),
            child: Column(
              children: [

                // Category filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: izabranaKategorija,
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.white,
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
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: GridView.builder(
                    itemCount: prikazaniFilmovi.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final film = prikazaniFilmovi[index];
                      return _buildMovieCard(film, context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Map<String, String> film, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FilmDetailScreen(film: film),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [

              Positioned.fill(
                child: Image.asset(
                  film['image']!,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  film['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
