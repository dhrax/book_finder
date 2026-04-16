import 'package:book_finder/app/router/app_routes.dart';
import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/core/models/book.dart';
import 'package:book_finder/features/favorites/favorites_page.dart';
import 'package:book_finder/features/search/search_page.dart';
import 'package:book_finder/features/search_history/search_history_page.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.controller, super.key});

  final LibraryController controller;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      SearchPage(controller: widget.controller, onOpenBook: _openBookDetail),
      FavoritesPage(controller: widget.controller, onOpenBook: _openBookDetail),
      SearchHistoryPage(
        controller: widget.controller,
        onSelectQuery: _selectHistoryQuery,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  void _openBookDetail(Book book) {
    Navigator.of(context).pushNamed(
      AppRoutes.bookDetail,
      arguments: BookDetailArgs(bookId: book.id),
    );
  }

  void _selectHistoryQuery(String query) {
    widget.controller.search(query);
    setState(() {
      _currentIndex = 0;
    });
  }
}
