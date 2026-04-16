import 'package:book_finder/core/models/book.dart';
import 'package:book_finder/core/repositories/book_repository.dart';
import 'package:flutter/foundation.dart';

enum LibrarySearchState { initial, loading, success, empty, error }

class LibraryController extends ChangeNotifier {
  LibraryController(this._repository);

  final BookRepository _repository;

  LibrarySearchState _searchState = LibrarySearchState.initial;
  List<Book> _searchResults = const [];
  String _query = '';
  String? _errorMessage;
  final Set<String> _favoriteBookIds = <String>{};
  final List<String> _searchHistory = <String>[];

  LibrarySearchState get searchState => _searchState;
  List<Book> get searchResults => _searchResults;
  String get query => _query;
  String? get errorMessage => _errorMessage;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  List<Book> get favoriteBooks {
    return _repository.allBooks
        .where((book) => _favoriteBookIds.contains(book.id))
        .toList(growable: false);
  }

  Future<void> loadFeaturedBooks() async {
    if (_searchState != LibrarySearchState.initial) {
      return;
    }

    await search('');
  }

  Future<void> search(String rawQuery) async {
    final normalizedQuery = rawQuery.trim();

    _query = normalizedQuery;
    _searchState = LibrarySearchState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.search(normalizedQuery);

      if (normalizedQuery.isNotEmpty) {
        _rememberQuery(normalizedQuery);
      }

      _searchResults = results;
      _searchState = results.isEmpty
          ? LibrarySearchState.empty
          : LibrarySearchState.success;
    } catch (_) {
      _searchResults = const [];
      _searchState = LibrarySearchState.error;
      _errorMessage = 'Something went wrong while loading books.';
    }

    notifyListeners();
  }

  Book? getBookById(String id) {
    return _repository.getById(id);
  }

  bool isFavorite(String bookId) {
    return _favoriteBookIds.contains(bookId);
  }

  void toggleFavorite(Book book) {
    if (_favoriteBookIds.contains(book.id)) {
      _favoriteBookIds.remove(book.id);
    } else {
      _favoriteBookIds.add(book.id);
    }

    notifyListeners();
  }

  void removeHistoryItem(String query) {
    if (_searchHistory.remove(query)) {
      notifyListeners();
    }
  }

  void clearHistory() {
    if (_searchHistory.isEmpty) {
      return;
    }

    _searchHistory.clear();
    notifyListeners();
  }

  void _rememberQuery(String query) {
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);

    if (_searchHistory.length > 8) {
      _searchHistory.removeRange(8, _searchHistory.length);
    }
  }
}
