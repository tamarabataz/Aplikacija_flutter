import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/films_provider.dart';
import '../models/film_model.dart';
import 'film_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<FilmModel> searchResults = [];

  @override
  Widget build(BuildContext context) {
    final filmsProvider = Provider.of<FilmsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pretraga filmova"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Pretraži film...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchResults = filmsProvider.searchFilms(value);
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final film = searchResults[index];
                  return ListTile(
                    leading: Image.asset(
                      film.imageUrl,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(film.title),
                    subtitle: Text(film.category),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FilmDetailScreen(
                            film: {
                              "title": film.title,
                              "image": film.imageUrl,
                              "category": film.category,
                            },
                            
                          ),
                        ),
                      );
                    },
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