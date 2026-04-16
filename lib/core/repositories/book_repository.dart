import 'package:book_finder/core/models/book.dart';

class BookRepository {
  BookRepository({List<Book>? seedBooks})
    : _books = List<Book>.unmodifiable(seedBooks ?? _seedBooks);

  final List<Book> _books;

  List<Book> get allBooks => _books;

  Future<List<Book>> search(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return _books;
    }

    return _books
        .where((book) {
          return book.title.toLowerCase().contains(normalizedQuery) ||
              book.author.toLowerCase().contains(normalizedQuery) ||
              book.description.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  Book? getById(String id) {
    for (final book in _books) {
      if (book.id == id) {
        return book;
      }
    }

    return null;
  }

  static const List<Book> _seedBooks = [
    Book(
      id: '1',
      title: 'The Pragmatic Programmer',
      author: 'Andrew Hunt and David Thomas',
      year: 1999,
      description:
          'A practical guide to building software with clarity, feedback, and craft.',
    ),
    Book(
      id: '2',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      year: 2008,
      description:
          'A handbook of habits that improve readability and long-term maintainability.',
    ),
    Book(
      id: '3',
      title: 'Atomic Habits',
      author: 'James Clear',
      year: 2018,
      description:
          'A framework for building small routines that compound into meaningful change.',
    ),
    Book(
      id: '4',
      title: 'Deep Work',
      author: 'Cal Newport',
      year: 2016,
      description:
          'An argument for focused work and deliberate concentration in a distracted world.',
    ),
    Book(
      id: '5',
      title: 'Flutter in Action',
      author: 'Eric Windmill',
      year: 2020,
      description:
          'A practical introduction to building production-ready apps with Flutter.',
    ),
    Book(
      id: '6',
      title: 'The Martian',
      author: 'Andy Weir',
      year: 2014,
      description:
          'A fast-moving survival story about problem solving, humor, and science on Mars.',
    ),
  ];
}
