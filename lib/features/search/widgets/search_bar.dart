import 'package:flutter/material.dart';

class BookSearchBar extends StatelessWidget {
  const BookSearchBar({
    required this.controller,
    required this.onSearch,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: onSearch,
            decoration: const InputDecoration(
              hintText: 'Search by title, author, or keyword',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () => onSearch(controller.text),
          icon: const Icon(Icons.auto_stories_outlined),
          label: const Text('Search'),
        ),
      ],
    );
  }
}
