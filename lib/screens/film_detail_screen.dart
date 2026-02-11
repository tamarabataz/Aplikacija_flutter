import 'package:flutter/material.dart';
import 'package:film_app/auth_service.dart';
class FilmDetailScreen extends StatefulWidget {
  final Map<String, String> film;

  const FilmDetailScreen({
    super.key,
    required this.film,
  });

  @override
  State<FilmDetailScreen> createState() => _FilmDetailScreenState();
}

class _FilmDetailScreenState extends State<FilmDetailScreen> {
  double rating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film['title']!),
        backgroundColor: const Color(0xFFB6895A),
      ),
      backgroundColor: const Color(0xFFD6AE7B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SLIKA
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.film['image']!,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // NASLOV
            Text(
              widget.film['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Kategorija: ${widget.film['category']}',
              style: TextStyle(
                color: Colors.brown.shade800,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Opis filma',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ovo je demo opis filma. Kasnije će se preuzimati iz baze ili API-ja.',
            ),

            const SizedBox(height: 24),

            // SAMO ZA ULOGOVANE
            if (AuthService.isLoggedIn) ...[
              const Text(
                'Oceni film',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),

              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    commentController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Komentar sačuvan (demo)'),
                      ),
                    );
                  },
                  child: const Text('Pošalji komentar'),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Prijavite se kako biste mogli da ocenjujete i komentarišete film.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}