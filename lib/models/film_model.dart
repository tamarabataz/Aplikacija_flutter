import 'package:flutter/material.dart';

class FilmModel with ChangeNotifier {
  final String filmId;
  final String title;
  final String category;
  final String imageUrl;
  final String description;

  FilmModel({
    required this.filmId,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
  });
}