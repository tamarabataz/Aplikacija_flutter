import 'package:flutter/material.dart';
import 'package:film_app/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:film_app/providers/wishlist_provider.dart';
import 'package:film_app/models/film_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FilmDetailScreen extends StatefulWidget {
  final FilmModel film;

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

  Future<void> _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Morate biti prijavljeni da pošaljete komentar.'),
        ),
      );
      return;
    }

    final comment = commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unesite komentar.'),
        ),
      );
      return;
    }

    if (rating <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izaberite ocenu pre slanja komentara.'),
        ),
      );
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data() ?? <String, dynamic>{};
      final userName = (userData['name'] ?? '').toString();

      await FirebaseFirestore.instance.collection('reviews').add({
        'filmId': widget.film.filmId,
        'userId': user.uid,
        'userName': userName,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      setState(() {
        rating = 0;
      });
      commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Komentar uspešno sačuvan.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Greška pri čuvanju komentara.'),
        ),
      );
    }
  }
  String _formatReviewDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dt = timestamp.toDate().toLocal();
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  Future<void> _showEditReviewDialog({
    required String reviewId,
    required String initialComment,
    required double initialRating,
  }) async {
    final commentEditController = TextEditingController(text: initialComment);
    double editRating = initialRating;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Izmeni komentar'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setDialogState(() {
                            editRating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < editRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                  TextField(
                    controller: commentEditController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Komentar',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Otkaži'),
                ),
                TextButton(
                  onPressed: () async {
                    final updatedComment = commentEditController.text.trim();
                    if (updatedComment.isEmpty) {
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection('reviews')
                        .doc(reviewId)
                        .update({
                      'comment': updatedComment,
                      'rating': editRating,
                      'updatedAt': Timestamp.now(),
                    });

                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Sačuvaj'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReviews() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('filmId', isEqualTo: widget.film.filmId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Jos nema komentara',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final docs = snapshot.data!.docs;
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final totalRating = docs.fold<double>(
          0,
          (currentTotal, doc) =>
              currentTotal + ((doc.data()['rating'] as num?)?.toDouble() ?? 0),
        );
        final averageRating = totalRating / docs.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < averageRating.round()
                          ? Colors.amber
                          : Colors.white30,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...docs.map((doc) {
              final data = doc.data();
              final reviewId = doc.id;
              final reviewUserId = (data['userId'] ?? '').toString();
              final userName = (data['userName'] ?? '').toString();
              final comment = (data['comment'] ?? '').toString();
              final reviewRating = (data['rating'] as num?)?.toDouble() ?? 0.0;
              final createdAt = data['createdAt'] as Timestamp?;
              final dateText = _formatReviewDate(createdAt);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < reviewRating.round()
                                ? Colors.amber
                                : Colors.white30,
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              comment,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          if (reviewUserId == currentUserId)
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white70,
                                size: 20,
                              ),
                              onPressed: () async {
                                await _showEditReviewDialog(
                                  reviewId: reviewId,
                                  initialComment: comment,
                                  initialRating: reviewRating,
                                );
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dateText,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.film.title),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, _) {
              final isInWishlist =
                  wishlistProvider.isInWishlist(widget.film.filmId);

              return IconButton(
                icon: Icon(
                  isInWishlist
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  if (AuthService.isLoggedIn) {
                    wishlistProvider
                        .toggleWishlist(widget.film.filmId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Morate biti prijavljeni da dodate u wishlist.",
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.film.imageUrl,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.film.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kategorija: ${widget.film.category}',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Opis filma',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.film.description,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                _buildReviews(),
                const SizedBox(height: 30),

                if (AuthService.isLoggedIn) ...[
                  const Text(
                    'Oceni film',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating
                              ? Icons.star
                              : Icons.star_border,
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
                    style:
                        const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Komentar',
                      hintStyle:
                          const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor:
                          Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE7C59A),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _submitReview,
                      child:
                          const Text('Pošalji komentar'),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Prijavite se kako biste mogli da ocenjujete i komentarišete film.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
