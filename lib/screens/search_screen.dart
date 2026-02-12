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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Pretraga filmova",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Pretraži film...",
                    hintStyle:
                        const TextStyle(color: Colors.white54),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        searchResults = [];
                      } else {
                        searchResults =
                            filmsProvider.searchFilms(value);
                      }
                    });
                  },
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            "Nema rezultata pretrage",
                            style: TextStyle(
                                color: Colors.white54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final film =
                                searchResults[index];

                            return Card(
                              color: Colors.white
                                  .withOpacity(0.05),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  child: Image.asset(
                                    film.imageUrl,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  film.title,
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                                subtitle: Text(
                                  film.category,
                                  style: const TextStyle(
                                      color: Colors.white70),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          FilmDetailScreen(
                                              film: film),
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