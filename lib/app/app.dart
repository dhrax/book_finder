import 'package:book_finder/app/router/app_router.dart';
import 'package:book_finder/app/router/app_routes.dart';
import 'package:book_finder/app/theme/app_theme.dart';
import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/core/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class BookFinderApp extends StatefulWidget {
  const BookFinderApp({this.repository, super.key});

  final BookRepository? repository;

  @override
  State<BookFinderApp> createState() => _BookFinderAppState();
}

class _BookFinderAppState extends State<BookFinderApp> {
  late final BookRepository _repository;
  late final LibraryController _controller;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? BookRepository();
    _controller = LibraryController(_repository);
  }

  @override
  void dispose() {
    _controller.dispose();
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        return AppRouter.onGenerateRoute(
          settings: settings,
          controller: _controller,
        );
      },
    );
  }
}
