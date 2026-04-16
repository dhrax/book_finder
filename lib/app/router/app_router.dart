import 'package:book_finder/app/app_shell.dart';
import 'package:book_finder/app/router/app_routes.dart';
import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/features/book_detail/book_detail_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute({
    required RouteSettings settings,
    required LibraryController controller,
  }) {
    switch (settings.name) {
      case AppRoutes.bookDetail:
        final args = settings.arguments;
        final bookId = args is BookDetailArgs ? args.bookId : '';

        return MaterialPageRoute<void>(
          builder: (_) =>
              BookDetailPage(controller: controller, bookId: bookId),
          settings: settings,
        );
      case AppRoutes.home:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => AppShell(controller: controller),
          settings: settings,
        );
    }
  }
}
