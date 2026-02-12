import 'package:flutter/material.dart';
import '../screens/film_list_screen.dart';
import 'add_edit_film_screen.dart';

class AdminFilmsScreen extends StatefulWidget {
  const AdminFilmsScreen({super.key});

  @override
  State<AdminFilmsScreen> createState() => _AdminFilmsScreenState();
}

class _AdminFilmsScreenState extends State<AdminFilmsScreen> {

  @override
  Widget build(BuildContext context) {
    final films = FilmListScreenState().films;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upravljanje filmovima"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditFilmScreen(),
            ),
          );
          setState(() {});
        },
      ),
      body: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films[index];

          return ListTile(
            leading: Image.asset(
              film['image']!,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(film['title']!),
            subtitle: Text(film['category']!),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  films.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}