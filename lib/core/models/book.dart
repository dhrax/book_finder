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
    final volumeInfo = _asStringKeyedMap(json['volumeInfo']);
    final imageLinks = _asStringKeyedMap(volumeInfo['imageLinks']);

    return Book(
      id: _readString(json['id']) ?? '',
      title: _readString(volumeInfo['title']) ?? 'Untitled',
      authors: _asStringList(volumeInfo['authors']),
      publishedDate: _readString(volumeInfo['publishedDate']),
      description: _readString(volumeInfo['description']),
      thumbnailUrl: _normalizeThumbnailUrl(
        _readString(imageLinks['thumbnail']) ??
            _readString(imageLinks['smallThumbnail']) ??
            _readString(imageLinks['small']) ??
            _readString(imageLinks['medium']),
      ),
      categories: _asStringList(volumeInfo['categories']),
      publisher: _readString(volumeInfo['publisher']),
      pageCount: _readInt(volumeInfo['pageCount']),
      averageRating: _readDouble(volumeInfo['averageRating']),
      ratingsCount: _readInt(volumeInfo['ratingsCount']),
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

    if (ratingsCount == null || ratingsCount == 0) {
      return averageRating!.toStringAsFixed(1);
    }

    return '${averageRating!.toStringAsFixed(1)} ($ratingsCount)';
  }

  static Map<String, dynamic> _asStringKeyedMap(Object? value) {
    final map = value as Map?;
    if (map == null) {
      return const <String, dynamic>{};
    }

    final result = <String, dynamic>{};
    for (final entry in map.entries) {
      final key = entry.key;
      if (key is String && key.isNotEmpty) {
        result[key] = entry.value;
      }
    }

    return result;
  }

  static List<String> _asStringList(Object? value) {
    final list = value as List?;
    if (list == null) {
      return const [];
    }

    final result = <String>[];
    for (final item in list) {
      final normalized = _readString(item);
      if (normalized != null) {
        result.add(normalized);
      }
    }

    return List.unmodifiable(result);
  }

  static String? _readString(Object? value) {
    if (value == null) {
      return null;
    }

    final normalized = value.toString().trim();
    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value > 0 ? value : null;
    }

    if (value is num) {
      final normalized = value.toInt();
      return normalized > 0 ? normalized : null;
    }

    final normalized = int.tryParse(_readString(value) ?? '');
    if (normalized == null || normalized <= 0) {
      return null;
    }

    return normalized;
  }

  static double? _readDouble(Object? value) {
    if (value is double) {
      return value >= 0 ? value : null;
    }

    if (value is num) {
      final normalized = value.toDouble();
      return normalized >= 0 ? normalized : null;
    }

    final normalized = double.tryParse(_readString(value) ?? '');
    if (normalized == null || normalized < 0) {
      return null;
    }

    return normalized;
  }

  static String? _normalizeThumbnailUrl(String? value) {
    final url = value?.trim();
    if (url == null || url.isEmpty) {
      return null;
    }

    if (url.startsWith('//')) {
      return 'https:$url';
    }

    if (url.startsWith('http://')) {
      return 'https://${url.substring(7)}';
    }

    return url;
  }
}
