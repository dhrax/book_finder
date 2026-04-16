import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/core/models/book.dart';
import 'package:book_finder/core/widgets/app_empty_state.dart';
import 'package:book_finder/core/widgets/book_list_tile.dart';
import 'package:book_finder/features/search/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    required this.controller,
    required this.onOpenBook,
    super.key,
  });

  final LibraryController controller;
  final ValueChanged<Book> onOpenBook;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController(
      text: widget.controller.query,
    );
    widget.controller.addListener(_syncSearchField);
    widget.controller.loadFeaturedBooks();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncSearchField);
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find your next great read',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Search the catalog, save favorites, and keep recent searches close by.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                BookSearchBar(
                  controller: _searchTextController,
                  onSearch: widget.controller.search,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.controller.query.isEmpty ? 'Browse books' : 'Results',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildBody()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (widget.controller.searchState) {
      case LibrarySearchState.initial:
      case LibrarySearchState.loading:
        return const Center(child: CircularProgressIndicator());
      case LibrarySearchState.empty:
        return const AppEmptyState(
          title: 'No books found',
          message: 'Try a different title, author, or a broader keyword.',
        );
      case LibrarySearchState.error:
        return AppEmptyState(
          title: 'Search unavailable',
          message:
              widget.controller.errorMessage ??
              'An unexpected error interrupted the search.',
        );
      case LibrarySearchState.success:
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: widget.controller.searchResults.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final book = widget.controller.searchResults[index];

            return BookListTile(
              book: book,
              isFavorite: widget.controller.isFavorite(book.id),
              onOpen: () => widget.onOpenBook(book),
              onToggleFavorite: () => widget.controller.toggleFavorite(book),
            );
          },
        );
    }
  }

  void _syncSearchField() {
    final query = widget.controller.query;

    if (_searchTextController.text == query) {
      return;
    }

    _searchTextController.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
  }
}
