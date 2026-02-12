import 'package:flutter/material.dart';
import '../models/film_model.dart';
import 'package:uuid/uuid.dart';

class FilmsProvider with ChangeNotifier {
  final List<FilmModel> _films = [
    FilmModel(
      filmId:  Uuid().v4(),
      title: "Ko to tamo peva",
      category: "Kultni",
      imageUrl: "assets/images/kototamopeva.jpg",
      description: "Kultni domaći film.",
    ),
    FilmModel(
      filmId:  Uuid().v4(),
      title: "Maratonci trče počasni krug",
      category: "Komedija",
      imageUrl: "assets/images/maratonci.webp",
      description: "Jedna od najboljih domaćih komedija.",
    ),
  ];

  List<FilmModel> get getFilms {
    return _films;
  }

  FilmModel? findById(String id) {
    try {
      return _films.firstWhere((film) => film.filmId == id);
    } catch (e) {
      return null;
    }
  }

  List<FilmModel> searchFilms(String query) {
    return _films
        .where((film) =>
            film.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<FilmModel> findByCategory(String category) {
    return _films
        .where((film) =>
            film.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}