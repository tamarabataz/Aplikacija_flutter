import 'package:flutter/material.dart';
import 'package:film_app/models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  final List<WishlistModel> _wishlist = [];

  List<WishlistModel> get wishlist => _wishlist;

  bool isInWishlist(String filmId) {
    return _wishlist.any((item) => item.filmId == filmId);
  }

  void toggleWishlist(String filmId) {
    if (isInWishlist(filmId)) {
      _wishlist.removeWhere((item) => item.filmId == filmId);
    } else {
      _wishlist.add(WishlistModel(filmId: filmId));
    }
    notifyListeners();
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}