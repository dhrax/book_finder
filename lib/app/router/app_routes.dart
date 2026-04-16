class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const bookDetail = '/book-detail';
}

class BookDetailArgs {
  const BookDetailArgs({required this.bookId});

  final String bookId;
}
