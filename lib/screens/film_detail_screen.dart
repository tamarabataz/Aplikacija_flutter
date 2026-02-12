import 'package:flutter/material.dart';
import 'package:film_app/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/wishlist_provider.dart';
import 'package:film_app/models/film_model.dart';

class FilmDetailScreen extends StatefulWidget {
  final FilmModel film;

  const FilmDetailScreen({
    super.key,
    required this.film,
  });

  @override
  State<FilmDetailScreen> createState() => _FilmDetailScreenState();
}

class _FilmDetailScreenState extends State<FilmDetailScreen> {
  double rating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.film.title),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, _) {
              final isInWishlist =
                  wishlistProvider.isInWishlist(widget.film.filmId);

              return IconButton(
                icon: Icon(
                  isInWishlist
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  if (AuthService.isLoggedIn) {
                    wishlistProvider
                        .toggleWishlist(widget.film.filmId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Morate biti prijavljeni da dodate u wishlist.",
                        ),
                      ),
                    );
                  }
                },
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
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.film.imageUrl,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.film.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kategorija: ${widget.film.category}',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Opis filma',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.film.description,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),

                if (AuthService.isLoggedIn) ...[
                  const Text(
                    'Oceni film',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    style:
                        const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Komentar',
                      hintStyle:
                          const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor:
                          Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE7C59A),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        commentController.clear();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Komentar sačuvan (demo)'),
                          ),
                        );
                      },
                      child:
                          const Text('Pošalji komentar'),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Prijavite se kako biste mogli da ocenjujete i komentarišete film.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
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
}