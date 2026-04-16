import 'dart:convert';

import 'package:book_finder/core/models/book.dart';
import 'package:http/http.dart' as http;

class BookRepository {
  BookRepository({http.Client? httpClient, String? apiKey})
    : _httpClient = httpClient ?? http.Client(),
      _apiKey = apiKey ?? const String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

  static const _baseUrl = 'www.googleapis.com';
  static const _defaultBrowseQuery = 'subject:fiction';

  final http.Client _httpClient;
  final String _apiKey;
  final Map<String, Book> _cachedBooksById = <String, Book>{};

  List<Book> get allBooks => _cachedBooksById.values.toList(growable: false);

  Future<List<Book>> search(String query) async {
    final normalizedQuery = query.trim();
    final effectiveQuery = normalizedQuery.isEmpty
        ? _defaultBrowseQuery
        : normalizedQuery;

    final queryParameters = <String, String>{
      'q': effectiveQuery,
      'maxResults': '20',
      'printType': 'books',
      'projection': 'full',
    };

    if (_apiKey.isNotEmpty) {
      queryParameters['key'] = _apiKey;
    }

    final response = await _httpClient.get(
      Uri.https(_baseUrl, '/books/v1/volumes', queryParameters),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load books (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (data['items'] as List?) ?? const [];

    final books = items
        .whereType<Map>()
        .map((item) => Book.fromGoogleBooksJson(item.cast<String, dynamic>()))
        .where((book) => book.id.isNotEmpty)
        .toList(growable: false);

    for (final book in books) {
      _cachedBooksById[book.id] = book;
    }

    return books;
  }

  Book? getById(String id) {
    return _cachedBooksById[id];
  }

  void dispose() {
    _httpClient.close();
  }
}
