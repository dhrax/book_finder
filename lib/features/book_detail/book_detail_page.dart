import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/core/models/book.dart';
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BookCover(book: book),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                book.authorsLabel,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _MetadataChip(label: book.publishedDateLabel),
                                  if (book.publisher != null &&
                                      book.publisher!.isNotEmpty)
                                    _MetadataChip(label: book.publisher!),
                                  if (book.pageCountLabel != null)
                                    _MetadataChip(label: book.pageCountLabel!),
                                  if (book.ratingLabel != null)
                                    _MetadataChip(
                                      label: 'Rating ${book.ratingLabel!}',
                                    ),
                                ],
                              ),
                            ],
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
                  if (book.categoriesLabel != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: book.categories
                          .map((category) => Chip(label: Text(category)))
                          .toList(growable: false),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'About this book',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    book.descriptionOrFallback,
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

class _BookCover extends StatelessWidget {
  const _BookCover({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 92,
        height: 132,
        color: colorScheme.surface,
        child: book.hasThumbnail
            ? Image.network(
                book.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: colorScheme.primary,
                  );
                },
              )
            : Icon(
                Icons.menu_book_rounded,
                size: 40,
                color: colorScheme.primary,
              ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
