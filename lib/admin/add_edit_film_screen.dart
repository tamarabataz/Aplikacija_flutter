import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/models/film_model.dart';
import 'package:uuid/uuid.dart';

class AddEditFilmScreen extends StatefulWidget {
  const AddEditFilmScreen({super.key});

  @override
  State<AddEditFilmScreen> createState() => _AddEditFilmScreenState();
}

class _AddEditFilmScreenState extends State<AddEditFilmScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj film")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Naziv filma"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Obavezno polje" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Kategorija"),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText:
                        "Putanja slike (npr assets/images/dolly.jpg)",
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: "Opis filma"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newFilm = FilmModel(
                        filmId: const Uuid().v4(),
                        title: titleController.text,
                        category: categoryController.text,
                        imageUrl: imageController.text,
                        description: descriptionController.text,
                      );

                      Provider.of<FilmsProvider>(context, listen: false)
                          .addFilm(newFilm);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Sačuvaj"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}