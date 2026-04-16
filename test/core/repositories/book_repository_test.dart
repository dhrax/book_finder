import 'package:book_finder/core/repositories/book_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'search maps partial Google Books data without crashing and uses safe defaults',
    () async {
      final repository = BookRepository(
        httpClient: MockClient((request) async {
          return http.Response(
            '''
            {
              "items": [
                {
                  "id": "partial-book",
                  "volumeInfo": {
                    "title": "  ",
                    "authors": ["", "Ada Lovelace", 7],
                    "publishedDate": 2024,
                    "description": "",
                    "imageLinks": {
                      "thumbnail": "//books.example.com/cover.jpg"
                    },
                    "categories": [null, "Computers", 42],
                    "publisher": "  ",
                    "pageCount": "250",
                    "averageRating": "4.5",
                    "ratingsCount": "0"
                  }
                },
                {
                  "id": "missing-volume-info"
                },
                "not-a-book"
              ]
            }
            ''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final books = await repository.search('flutter');

      expect(books, hasLength(2));

      final partialBook = books.firstWhere((book) => book.id == 'partial-book');
      expect(partialBook.title, 'Untitled');
      expect(partialBook.authors, ['Ada Lovelace', '7']);
      expect(partialBook.authorsLabel, 'Ada Lovelace, 7');
      expect(partialBook.publishedDate, '2024');
      expect(partialBook.publishedDateLabel, '2024');
      expect(partialBook.description, isNull);
      expect(partialBook.descriptionOrFallback, 'No description available.');
      expect(partialBook.thumbnailUrl, 'https://books.example.com/cover.jpg');
      expect(partialBook.categories, ['Computers', '42']);
      expect(partialBook.categoriesLabel, 'Computers, 42');
      expect(partialBook.publisher, isNull);
      expect(partialBook.pageCount, 250);
      expect(partialBook.pageCountLabel, '250 pages');
      expect(partialBook.averageRating, 4.5);
      expect(partialBook.ratingsCount, isNull);
      expect(partialBook.ratingLabel, '4.5');

      final missingVolumeInfo = books.firstWhere(
        (book) => book.id == 'missing-volume-info',
      );
      expect(missingVolumeInfo.title, 'Untitled');
      expect(missingVolumeInfo.authorsLabel, 'Unknown author');
      expect(missingVolumeInfo.publishedDateLabel, 'Unknown date');
      expect(
        missingVolumeInfo.descriptionOrFallback,
        'No description available.',
      );
      expect(missingVolumeInfo.thumbnailUrl, isNull);
      expect(missingVolumeInfo.categories, isEmpty);
      expect(missingVolumeInfo.pageCount, isNull);
      expect(missingVolumeInfo.averageRating, isNull);
      expect(repository.getById('partial-book'), isNotNull);
    },
  );
}
