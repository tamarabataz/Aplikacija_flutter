import 'package:flutter/material.dart';
import 'package:film_app/models/film_model.dart';
import 'package:uuid/uuid.dart';

class FilmsProvider with ChangeNotifier {
  final List<FilmModel> _films = [
    FilmModel(
      filmId: const Uuid().v4(),
      title: "Ko to tamo peva",
      category: "Kultni",
      imageUrl: "assets/images/kototamopeva.jpg",
      description: "Kultni domaći film.",
      isPopular: true,
      isNew: false,
    ),
    FilmModel(
      filmId: const Uuid().v4(),
      title: "Maratonci trče počasni krug",
      category: "Komedija",
      imageUrl: "assets/images/maratonci.webp",
      description: "Jedna od najboljih domaćih komedija.",
      isPopular: true,
      isNew: true,
    ),
  ];

  List<FilmModel> get getFilms => _films;

  void addFilm(FilmModel film) {
    _films.add(film);
    notifyListeners();
  }

  void removeFilm(String id) {
    _films.removeWhere((film) => film.filmId == id);
    notifyListeners();
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

  List<FilmModel> get popularFilms =>
    _films.where((film) => film.isPopular).toList();

List<FilmModel> get newFilms =>
    _films.where((film) => film.isNew).toList();


}