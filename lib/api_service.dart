import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '4e6069ee66df42d092cacc0d572c0bfd';
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<dynamic>> fetchTopHeadlines({int page = 1}) async {
    final List<dynamic> articles = [];

    final responseArabic = await http.get(Uri.parse('$baseUrl?language=ar&page=$page&apiKey=$apiKey'));
    if (responseArabic.statusCode == 200) {
      articles.addAll(json.decode(responseArabic.body)['articles']);
    } else {
      throw Exception('Failed to load Arabic news');
    }

    final responseEnglish = await http.get(Uri.parse('$baseUrl?language=en&page=$page&apiKey=$apiKey'));
    if (responseEnglish.statusCode == 200) {
      articles.addAll(json.decode(responseEnglish.body)['articles']);
    } else {
      throw Exception('Failed to load English news');
    }

    return articles;
  }
}
