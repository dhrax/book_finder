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
          final searchableParts = [
            book.title,
            book.authors.join(' '),
            book.description ?? '',
            book.publisher ?? '',
            book.categories.join(' '),
          ];

          return searchableParts
              .join(' ')
              .toLowerCase()
              .contains(normalizedQuery);
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
      authors: ['Andrew Hunt', 'David Thomas'],
      publishedDate: '1999-10-30',
      description:
          'A practical guide to building software with clarity, feedback, and craft.',
      categories: ['Computers', 'Software Engineering'],
      publisher: 'Addison-Wesley',
      pageCount: 352,
      averageRating: 4.6,
      ratingsCount: 245,
    ),
    Book(
      id: '2',
      title: 'Clean Code',
      authors: ['Robert C. Martin'],
      publishedDate: '2008-08-01',
      description:
          'A handbook of habits that improve readability and long-term maintainability.',
      categories: ['Computers', 'Programming'],
      publisher: 'Prentice Hall',
      pageCount: 464,
      averageRating: 4.5,
      ratingsCount: 318,
    ),
    Book(
      id: '3',
      title: 'Atomic Habits',
      authors: ['James Clear'],
      publishedDate: '2018-10-16',
      description:
          'A framework for building small routines that compound into meaningful change.',
      categories: ['Self-Help', 'Psychology'],
      publisher: 'Avery',
      pageCount: 320,
      averageRating: 4.8,
      ratingsCount: 512,
    ),
    Book(
      id: '4',
      title: 'Deep Work',
      authors: ['Cal Newport'],
      publishedDate: '2016-01-05',
      description:
          'An argument for focused work and deliberate concentration in a distracted world.',
      categories: ['Business', 'Self-Help'],
      publisher: 'Grand Central Publishing',
      pageCount: 304,
      averageRating: 4.2,
      ratingsCount: 189,
    ),
    Book(
      id: '5',
      title: 'Flutter in Action',
      authors: ['Eric Windmill'],
      publishedDate: '2020-01-07',
      description:
          'A practical introduction to building production-ready apps with Flutter.',
      categories: ['Computers', 'Mobile'],
      publisher: 'Manning',
      pageCount: 360,
      averageRating: 4.1,
      ratingsCount: 64,
    ),
    Book(
      id: '6',
      title: 'The Martian',
      authors: ['Andy Weir'],
      publishedDate: '2014-02-11',
      description:
          'A fast-moving survival story about problem solving, humor, and science on Mars.',
      categories: ['Fiction', 'Science Fiction'],
      publisher: 'Crown',
      pageCount: 384,
      averageRating: 4.7,
      ratingsCount: 420,
    ),
  ];
}
