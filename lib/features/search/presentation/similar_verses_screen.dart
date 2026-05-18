import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_providers.dart';
import '../../../core/models/bible_location.dart';
import 'search_results_list.dart';

class SimilarVersesScreen extends ConsumerWidget {
  const SimilarVersesScreen({
    required this.location,
    super.key,
  });

  final BibleLocation location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(similarVersesProvider(location));
    final label = ref.watch(locationLabelProvider(location));

    return Scaffold(
      appBar: AppBar(
        title: label.when(
          data: (value) => Text('\u76f8\u4f3c\u7ecf\u6587 \u00b7 $value'),
          loading: () => const Text('\u76f8\u4f3c\u7ecf\u6587'),
          error: (_, _) => const Text('\u76f8\u4f3c\u7ecf\u6587'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: results.when(
          data: (items) => SearchResultsList(
            items: items,
            emptyMessage: '\u6682\u65f6\u6ca1\u6709\u627e\u5230\u76f8\u4f3c\u7ecf\u6587\u3002',
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(semanticSearchErrorMessage(error)),
          ),
        ),
      ),
    );
  }
}
