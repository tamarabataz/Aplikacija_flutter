import 'package:film_app/providers/films_provider.dart';
import 'package:film_app/models/film_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditFilmScreen extends StatefulWidget {
  final FilmModel? film;

  const AddEditFilmScreen({super.key, this.film});

  @override
  State<AddEditFilmScreen> createState() => _AddEditFilmScreenState();
}

class _AddEditFilmScreenState extends State<AddEditFilmScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isPopular = false;
  bool isNew = false;
  bool isSaving = false;

  bool get isEditMode => widget.film != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final film = widget.film!;
      titleController.text = film.title;
      categoryController.text = film.category;
      imageController.text = film.imageUrl;
      descriptionController.text = film.description;
      isPopular = film.isPopular;
      isNew = film.isNew;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveFilm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final filmsProvider = Provider.of<FilmsProvider>(
        context,
        listen: false,
      );

      if (isEditMode) {
        final updatedFilm = FilmModel(
          filmId: widget.film!.filmId,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: categoryController.text.trim(),
          imageUrl: imageController.text.trim(),
          isPopular: isPopular,
          isNew: isNew,
        );
        await filmsProvider.updateFilmInFirestore(updatedFilm);
      } else {
        await filmsProvider.addFilmToFirestore(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: categoryController.text.trim(),
          imageUrl: imageController.text.trim(),
          isPopular: isPopular,
          isNew: isNew,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Greska pri cuvanju filma: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Izmeni film' : 'Dodaj film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Naslov filma'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Obavezno polje'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Opis filma'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Obavezno polje'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Kategorija'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Obavezno polje'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Slika (URL ili putanja)',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Obavezno polje'
                      : null,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Popular'),
                  value: isPopular,
                  onChanged: (value) {
                    setState(() {
                      isPopular = value;
                    });
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('New'),
                  value: isNew,
                  onChanged: (value) {
                    setState(() {
                      isNew = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _saveFilm,
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditMode ? 'Sačuvaj izmene' : 'Sacuvaj'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
