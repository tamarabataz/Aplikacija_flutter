import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/wishlist_provider.dart';
import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/screens/film_detail_screen.dart';
import 'package:film_app/models/film_model.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final filmsProvider = Provider.of<FilmsProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background
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

          wishlistProvider.wishlist.isEmpty
              ? const Center(
                  child: Text(
                    "Nema dodatih filmova ❤️",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
              : Padding(
  padding: const EdgeInsets.only(top: 110, left: 16, right: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "❤️ Moji omiljeni filmovi",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      const SizedBox(height: 20),

      Expanded(
        child: ListView.builder(
          itemCount: wishlistProvider.wishlist.length,
          itemBuilder: (context, index) {
            final filmId =
                wishlistProvider.wishlist[index].filmId;

            final film =
                filmsProvider.findById(filmId);

            if (film == null) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                tileColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    film.imageUrl,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  film.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  film.category,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    wishlistProvider
                        .toggleWishlist(film.filmId);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FilmDetailScreen(film: film),
                    ),
                  );
                },
              ),
            );
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
}