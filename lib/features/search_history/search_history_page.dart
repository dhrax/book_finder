import 'package:book_finder/core/controllers/library_controller.dart';
import 'package:book_finder/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({
    required this.controller,
    required this.onSelectQuery,
    super.key,
  });

  final LibraryController controller;
  final ValueChanged<String> onSelectQuery;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final history = controller.searchHistory;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Search history',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (history.isNotEmpty)
                      TextButton(
                        onPressed: controller.clearHistory,
                        child: const Text('Clear all'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Recent queries stay here so you can rerun them with one tap.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: history.isEmpty
                      ? const AppEmptyState(
                          title: 'No searches yet',
                          message:
                              'Your recent search terms will show up here automatically.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: history.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final query = history[index];

                            return Card(
                              child: ListTile(
                                onTap: () => onSelectQuery(query),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                leading: const Icon(Icons.history),
                                title: Text(query),
                                trailing: IconButton(
                                  onPressed: () =>
                                      controller.removeHistoryItem(query),
                                  icon: const Icon(Icons.close),
                                  tooltip: 'Remove from history',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
