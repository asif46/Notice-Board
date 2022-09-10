import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Notificationn with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  String timestamp;
  final String noticetype;
  final String session;
  //final double price;
  String imageUrl;
  bool isFavorite;

  Notificationn({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.timestamp,
    @required this.noticetype,
    @required this.session,
    //@required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });


  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://notice-board-app-2afdd-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
