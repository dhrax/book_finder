import 'package:book_finder/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the Book Finder home screen', (tester) async {
    await tester.pumpWidget(const BookFinderApp());
    await tester.pumpAndSettle();

    expect(find.text('Find your next great read'), findsOneWidget);
    expect(find.text('Search'), findsWidgets);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('The Pragmatic Programmer'), findsOneWidget);
  });
}
