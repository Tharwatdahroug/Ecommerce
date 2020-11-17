import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorite(bool newValue) {
    isFavorite = newValue;
     notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String toke,String userId) async {
    var oldisFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://flutter-6dd8e.firebaseio.com/userFavorites/$userId/$id.json?auth=$toke';
    try {
      final response = await http.put(
        url,
        body: json.encode( isFavorite),
      );
      if (response.statusCode >= 400) {
        _setFavorite(oldisFavorite);
      }
    } catch (error) {
      _setFavorite(oldisFavorite);
      notifyListeners();
    }
  }
}
