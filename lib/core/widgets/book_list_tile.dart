import 'package:book_finder/core/models/book.dart';
import 'package:flutter/material.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({
    required this.book,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    super.key,
  });

  final Book book;
  final bool isFavorite;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookThumbnail(book: book),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.authorsLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _buildMetaLine(book),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.descriptionOrFallback,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? colorScheme.primary : null,
                ),
                tooltip: isFavorite ? 'Remove favorite' : 'Save favorite',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildMetaLine(Book book) {
    final parts = <String>[
      book.publishedDateLabel,
      if (book.publisher != null && book.publisher!.isNotEmpty) book.publisher!,
    ];

    return parts.join(' • ');
  }
}

class _BookThumbnail extends StatelessWidget {
  const _BookThumbnail({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 54,
        height: 76,
        color: colorScheme.primaryContainer,
        child: book.hasThumbnail
            ? Image.network(
                book.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.menu_book_rounded,
                    color: colorScheme.onPrimaryContainer,
                  );
                },
              )
            : Icon(
                Icons.menu_book_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
      ),
    );
  }
}
