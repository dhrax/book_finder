import 'package:book_finder/app/app.dart';
import 'package:book_finder/core/repositories/book_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('renders the Book Finder home screen', (tester) async {
    final repository = BookRepository(
      httpClient: MockClient((request) async {
        return http.Response(
          '''
          {
            "items": [
              {
                "id": "test-volume",
                "volumeInfo": {
                  "title": "The Pragmatic Programmer",
                  "authors": ["Andrew Hunt", "David Thomas"],
                  "publishedDate": "1999-10-30",
                  "description": "A practical guide to building software with clarity, feedback, and craft."
                }
              }
            ],
            "totalItems": 1
          }
          ''',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await tester.pumpWidget(BookFinderApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Find your next great read'), findsOneWidget);
    expect(find.text('Search'), findsWidgets);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('The Pragmatic Programmer'), findsOneWidget);
  });
}
