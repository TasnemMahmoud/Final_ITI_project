import 'package:flutter/material.dart';
import 'api_service.dart';

class NewsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _articles = [];
  bool _loading = false;
  int _page = 1;
  bool _hasMore = true;

  List<dynamic> get articles => _articles;
  bool get loading => _loading;
  bool get hasMore => _hasMore;

  Future<void> fetchNews({bool loadMore = false}) async {
    if (loadMore) {
      _page++;
    } else {
      _page = 1;
      _articles = [];
    }

    _loading = true;
    notifyListeners();

    try {
      final newArticles = await _apiService.fetchTopHeadlines(page: _page);
      if (newArticles.isEmpty) {
        _hasMore = false;
      } else {
        _articles.addAll(newArticles);
      }
    } catch (e) {
      _articles = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
