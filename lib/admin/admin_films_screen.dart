import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/models/film_model.dart';
import 'add_edit_film_screen.dart';

class AdminFilmsScreen extends StatelessWidget {
  const AdminFilmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filmsProvider = Provider.of<FilmsProvider>(context);
    final films = filmsProvider.getFilms;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upravljanje filmovima"),
      ),
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
            leading: Image.asset(
              film.imageUrl,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(film.title),
            subtitle: Text(film.category),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                filmsProvider.removeFilm(film.filmId);
              },
            ),
          );
        },
      ),
    );
  }
}