import 'package:flutter/material.dart';

class FeedCacheProvider with ChangeNotifier {
  List<Map<String, dynamic>> _feedStateProps = [];

  List<Map<String, dynamic>> get feedStateProps => _feedStateProps;

  void setFeeds(List<Map<String, dynamic>> feeds) {
    _feedStateProps = feeds;
    notifyListeners();
  }

  bool getFeedState(int id) {
    if (id >= 0 && id < _feedStateProps.length) {
      return _feedStateProps[id]['state'] ?? false;
    }
    return false;
  }

  void toggleFeedState(int index) {
    _feedStateProps[index]['state'] = !_feedStateProps[index]['state'];
    notifyListeners();
  }
}