import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'notificationn.dart';
import 'auth.dart';

class Notifications with ChangeNotifier {
  List<Notificationn> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;
  String authToken;
  String userId;
  
  //Products(this.authToken, this.userId, this._items);
  void recieveToken(Auth auth, List<Notificationn> items){
    authToken = auth.token;
    userId = auth.userId;
    _items = items;
  }

  List<Notificationn> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Notificationn> get favoriteItems {
    return _items.where((noticeItem) => noticeItem.isFavorite).toList();
  }

  Notificationn findById(String id) {
    return _items.firstWhere((notice) => notice.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetNotifications() async {
    //final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://notice-board-app-2afdd-default-rtdb.firebaseio.com/notifications.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://notice-board-app-2afdd-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Notificationn> loadedNotifications = [];
      extractedData.forEach((noticeId, noticeData) {
        loadedNotifications.add(Notificationn(
          id: noticeId,
          title: noticeData['title'],
          description: noticeData['description'],
          //price: noticeData['price'],
          timestamp: noticeData['timeStamp'],
          session: noticeData['session'],
          noticetype: noticeData['noticetype'],
          isFavorite:
              favoriteData == null ? false : favoriteData[noticeId] ?? false,
          imageUrl: noticeData['imageUrl'],
        ));
      });
      _items = loadedNotifications;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addNotificationn(Notificationn notificationn) async {
    final url =
        'https://notice-board-app-2afdd-default-rtdb.firebaseio.com/notifications.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': notificationn.title,
          'description': notificationn.description,
          'imageUrl': notificationn.imageUrl,
          //'price': notificationn.price,
          'creatorId': userId,
          'timeStamp': notificationn.timestamp,
          'noticetype': notificationn.noticetype,
        }),
      );
      final newNotificationn = Notificationn(
        title: notificationn.title,
        description: notificationn.description,
        timestamp: notificationn.timestamp,
        noticetype: notificationn.noticetype,
        session: notificationn.session,
        //price: notificationn.price,
        imageUrl: notificationn.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newNotificationn);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateNotificationn(String id, Notificationn newNotificationn) async {
    final noticeIndex = _items.indexWhere((notice) => notice.id == id);
    if (noticeIndex >= 0) {
      final url =
          'https://notice-board-app-2afdd-default-rtdb.firebaseio.com/notifications/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newNotificationn.title,
            'description': newNotificationn.description,
            'imageUrl': newNotificationn.imageUrl,
            'timeStamp': newNotificationn.timestamp,
            'noticetype': newNotificationn.noticetype,
            //'price': newNotificationn.price
          }));
      _items[noticeIndex] = newNotificationn;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteNotificationn(String id) async {
    final url =
        'https://notice-board-app-2afdd-default-rtdb.firebaseio.com/notifications/$id.json?auth=$authToken';
    final existingNotificationnIndex = _items.indexWhere((notice) => notice.id == id);
    var existingNotificationn = _items[existingNotificationnIndex];
    _items.removeAt(existingNotificationnIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingNotificationnIndex, existingNotificationn);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingNotificationn = null;
  }
}
