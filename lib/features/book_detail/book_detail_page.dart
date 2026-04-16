import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({
    required this.controller,
    required this.bookId,
    super.key,
  });

  final LibraryController controller;
  final String bookId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final book = controller.getBookById(bookId);

        if (book == null) {
          return const Scaffold(
            body: SafeArea(
              child: AppEmptyState(
                title: 'Book not found',
                message:
                    'This book could not be loaded from the local catalog.',
              ),
            ),
          );
        }

        final isFavorite = controller.isFavorite(book.id);

        return Scaffold(
          appBar: AppBar(title: const Text('Book detail')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${book.author} - ${book.year}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => controller.toggleFavorite(book),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite
                          ? 'Remove from favorites'
                          : 'Save to favorites',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About this book',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    book.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
