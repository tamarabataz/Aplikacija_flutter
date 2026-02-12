import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/wishlist_provider.dart';
import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/models/film_model.dart';
import 'package:film_app/auth_service.dart';

import 'login_screen.dart';
import 'signup_screen.dart';
import 'film_detail_screen.dart';
import 'search_screen.dart';
import 'package:film_app/admin/admin_dashboard_screen.dart';

class FilmListScreen extends StatefulWidget {
  const FilmListScreen({super.key});

  @override
  State<FilmListScreen> createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<FilmsProvider>(context, listen: false).fetchFilms());
  }

  final List<String> kategorije = [
    'Sve',
    'Kultni',
    'Komedija',
    'Drama',
  ];

  String izabranaKategorija = 'Sve';

  @override
  Widget build(BuildContext context) {
    final filmsProvider = Provider.of<FilmsProvider>(context);
    final popularFilms = filmsProvider.popularFilms;
    final newFilms = filmsProvider.newFilms;

    final prikazaniFilmovi = izabranaKategorija == 'Sve'
        ? filmsProvider.getFilms
        : filmsProvider.findByCategory(izabranaKategorija);

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
          FutureBuilder<bool>(
            future: AuthService.instance.isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
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
            onPressed: () async {
              await AuthService.instance.logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
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
            padding: const EdgeInsets.only(top: 110, left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 NAJGLEDANIJI
                  if (popularFilms.isNotEmpty) ...[
                    const Text(
                      "Najgledaniji filmovi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: 12),
                      height: 2,
                      width: 120,
                      color: Color(0xFFE7C59A),
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularFilms.length,
                        itemBuilder: (context, index) {
                          return _buildHorizontalCard(
                              popularFilms[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],

                  /// 🆕 NOVI
                  if (newFilms.isNotEmpty) ...[
                    const Text(
                      "Novi dodati filmovi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: 12),
                      height: 2,
                      width: 120,
                      color: Color(0xFFE7C59A),
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newFilms.length,
                        itemBuilder: (context, index) {
                          return _buildHorizontalCard(
                              newFilms[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],

                  /// FILTER
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

                  /// GRID
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prikazaniFilmovi.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      return _buildMovieCard(
                          prikazaniFilmovi[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCard(FilmModel film) {
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
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(film.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCard(FilmModel film) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isInWishlist =
        wishlistProvider.isInWishlist(film.filmId);

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
                  film.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(
                    isInWishlist
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    wishlistProvider.toggleWishlist(film.filmId);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
