import 'package:flutter/material.dart';
import '../screens/film_list_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final films = FilmListScreenState().films;

    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj film")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Naziv filma"),
                validator: (value) =>
                    value!.isEmpty ? "Obavezno polje" : null,
              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Kategorija"),
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                    labelText: "Putanja slike (npr assets/images/dolly.jpg)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    films.add({
                      'title': titleController.text,
                      'category': categoryController.text,
                      'image': imageController.text,
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Sačuvaj"),
              )
            ],
          ),
        ),
      ),
    );
  }
}