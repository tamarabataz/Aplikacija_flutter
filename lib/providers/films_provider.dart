import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_app/models/film_model.dart';

class FilmsProvider with ChangeNotifier {
  List<FilmModel> _films = [];

  List<FilmModel> get getFilms => _films;

  List<FilmModel> get popularFilms =>
      _films.where((film) => film.isPopular).toList();

  List<FilmModel> get newFilms => _films.where((film) => film.isNew).toList();

  List<FilmModel> findByCategory(String category) =>
      _films.where((film) => film.category == category).toList();

  Future<void> fetchFilms() async {
    final snapshot = await FirebaseFirestore.instance.collection('films').get();

    _films = snapshot.docs.map((doc) {
      final data = doc.data();

      return FilmModel(
        filmId: doc.id,
        title: data['title'] ?? '',
        category: data['category'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        description: data['description'] ?? '',
        isPopular: data['isPopular'] ?? false,
        isNew: data['isNew'] ?? false,
      );
    }).toList();

    notifyListeners();
  }

  void addFilm(FilmModel film) {
    _films.add(film);
    notifyListeners();
  }

  Future<void> addFilmToFirestore({
    required String title,
    required String description,
    required String category,
    required String imageUrl,
    required bool isPopular,
    required bool isNew,
  }) async {
    await FirebaseFirestore.instance.collection('films').add({
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
      'isNew': isNew,
      'createdAt': Timestamp.now(),
    });

    await fetchFilms();
    notifyListeners();
  }

  Future<void> deleteFilmFromFirestore(String filmId) async {
    await FirebaseFirestore.instance.collection('films').doc(filmId).delete();
    await fetchFilms();
    notifyListeners();
  }

  Future<void> updateFilmInFirestore(FilmModel film) async {
    await FirebaseFirestore.instance.collection('films').doc(film.filmId).update({
      'title': film.title,
      'description': film.description,
      'category': film.category,
      'imageUrl': film.imageUrl,
      'isPopular': film.isPopular,
      'isNew': film.isNew,
    });

    await fetchFilms();
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
        .where((film) => film.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
