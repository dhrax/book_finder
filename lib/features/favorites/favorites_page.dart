import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/core/models/book.dart';
import 'package:book_finder/core/widgets/app_empty_state.dart';
import 'package:book_finder/core/widgets/book_list_tile.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    required this.controller,
    required this.onOpenBook,
    super.key,
  });

  final LibraryController controller;
  final ValueChanged<Book> onOpenBook;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final favorites = controller.favoriteBooks;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favorites',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A short list of books you want to revisit quickly.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: favorites.isEmpty
                      ? const AppEmptyState(
                          title: 'No favorites yet',
                          message:
                              'Tap the heart on any book to keep it handy here.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: favorites.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final book = favorites[index];

                            return BookListTile(
                              book: book,
                              isFavorite: controller.isFavorite(book.id),
                              onOpen: () => onOpenBook(book),
                              onToggleFavorite: () =>
                                  controller.toggleFavorite(book),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
