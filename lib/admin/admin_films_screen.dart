import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/models/film_model.dart';
import 'add_edit_film_screen.dart';

class AdminFilmsScreen extends StatelessWidget {
  const AdminFilmsScreen({super.key});

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    FilmModel film,
  ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text(
            "Da li ste sigurni da \u017eelite da obri\u0161ete film?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("Otka\u017ei"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Obri\u0161i"),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await Provider.of<FilmsProvider>(context, listen: false)
          .deleteFilmFromFirestore(film.filmId);
    }
  }

  Widget _buildFilmImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }

    return Image.asset(
      imageUrl,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filmsProvider = Provider.of<FilmsProvider>(context);
    final films = filmsProvider.getFilms;

    return Scaffold(
      appBar: AppBar(title: const Text("Upravljanje filmovima")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditFilmScreen(),
            ),
          );
        },
      ),
      body: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final FilmModel film = films[index];

          return ListTile(
            leading: _buildFilmImage(film.imageUrl),
            title: Text(film.title),
            subtitle: Text(film.category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditFilmScreen(film: film),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _showDeleteConfirmationDialog(context, film);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
