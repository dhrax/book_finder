# Book Finder

A small Flutter app starter structured with a lightweight feature-first architecture.

## Structure

```text
lib/
  app/
    app.dart
    app_shell.dart
    router/
    theme/
  core/
    controllers/
    models/
    repositories/
    widgets/
  features/
    search/
    book_detail/
    favorites/
    search_history/
```

## Responsibilities

- `app/`: app bootstrap, navigation, theme, and the shell that ties the feature screens together.
- `core/`: small shared pieces used by multiple features, such as the `Book` model, in-memory repository, app controller, and reusable widgets.
- `features/`: one folder per user-facing feature. Each feature keeps only the UI and feature-specific pieces it actually needs.

This setup is intentionally light for a personal app: shared data and state live in `core/`, while the initial features stay easy to scan and expand without adding separate domain or use-case layers too early.
