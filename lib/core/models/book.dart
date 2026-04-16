class Book {
  const Book({
    required this.id,
    required this.title,
    this.authors = const [],
    this.publishedDate,
    this.description,
    this.thumbnailUrl,
    this.categories = const [],
    this.publisher,
    this.pageCount,
    this.averageRating,
    this.ratingsCount,
  });

  final String id;
  final String title;
  final List<String> authors;
  final String? publishedDate;
  final String? description;
  final String? thumbnailUrl;
  final List<String> categories;
  final String? publisher;
  final int? pageCount;
  final double? averageRating;
  final int? ratingsCount;

  factory Book.fromGoogleBooksJson(Map<String, dynamic> json) {
    final volumeInfo =
        (json['volumeInfo'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final imageLinks =
        (volumeInfo['imageLinks'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};

    return Book(
      id: json['id'] as String? ?? '',
      title: volumeInfo['title'] as String? ?? 'Untitled',
      authors: _asStringList(volumeInfo['authors']),
      publishedDate: volumeInfo['publishedDate'] as String?,
      description: volumeInfo['description'] as String?,
      thumbnailUrl: _normalizeThumbnailUrl(
        imageLinks['thumbnail'] as String? ??
            imageLinks['smallThumbnail'] as String?,
      ),
      categories: _asStringList(volumeInfo['categories']),
      publisher: volumeInfo['publisher'] as String?,
      pageCount: (volumeInfo['pageCount'] as num?)?.toInt(),
      averageRating: (volumeInfo['averageRating'] as num?)?.toDouble(),
      ratingsCount: (volumeInfo['ratingsCount'] as num?)?.toInt(),
    );
  }

  String get authorsLabel {
    if (authors.isEmpty) {
      return 'Unknown author';
    }

    return authors.join(', ');
  }

  String get publishedDateLabel {
    final value = publishedDate?.trim();
    if (value == null || value.isEmpty) {
      return 'Unknown date';
    }

    return value;
  }

  String get descriptionOrFallback {
    final value = description?.trim();
    if (value == null || value.isEmpty) {
      return 'No description available.';
    }

    return value;
  }

  bool get hasThumbnail {
    final value = thumbnailUrl?.trim();
    return value != null && value.isNotEmpty;
  }

  String? get categoriesLabel {
    if (categories.isEmpty) {
      return null;
    }

    return categories.join(', ');
  }

  String? get pageCountLabel {
    if (pageCount == null) {
      return null;
    }

    return '$pageCount pages';
  }

  String? get ratingLabel {
    if (averageRating == null) {
      return null;
    }

    if (ratingsCount == null) {
      return averageRating!.toStringAsFixed(1);
    }

    return '${averageRating!.toStringAsFixed(1)} ($ratingsCount)';
  }

  static List<String> _asStringList(Object? value) {
    final list = value as List?;
    if (list == null) {
      return const [];
    }

    return list.whereType<String>().toList(growable: false);
  }

  static String? _normalizeThumbnailUrl(String? value) {
    final url = value?.trim();
    if (url == null || url.isEmpty) {
      return null;
    }

    if (url.startsWith('http://')) {
      return 'https://${url.substring(7)}';
    }

    return url;
  }
}
