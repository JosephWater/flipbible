import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_providers.dart';
import '../../../core/models/search_hit.dart';
import 'search_results_list.dart';

enum SearchMode {
  keyword,
  semantic,
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  SearchMode _mode = SearchMode.keyword;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTranslation = ref.watch(activeTranslationProvider);
    final semanticAvailable =
        activeTranslation.asData?.value?.hasSemanticIndex ?? false;
    final results = _mode == SearchMode.semantic && semanticAvailable
        ? ref.watch(semanticSearchResultsProvider(_query))
        : ref.watch(searchResultsProvider(_query));

    return Scaffold(
      appBar: AppBar(title: const Text('\u641c\u7d22')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            SegmentedButton<SearchMode>(
              selected: {_mode},
              segments: const [
                ButtonSegment<SearchMode>(
                  value: SearchMode.keyword,
                  label: Text('\u5173\u952e\u8bcd'),
                  icon: Icon(Icons.manage_search_rounded),
                ),
                ButtonSegment<SearchMode>(
                  value: SearchMode.semantic,
                  label: Text('\u8bed\u4e49'),
                  icon: Icon(Icons.auto_awesome_rounded),
                ),
              ],
              onSelectionChanged: (selection) {
                final selected = selection.first;
                if (selected == SearchMode.semantic && !semanticAvailable) {
                  return;
                }
                setState(() {
                  _mode = selected;
                  _query = _controller.text;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: _mode == SearchMode.keyword
                    ? '\u8f93\u5165\u5173\u952e\u8bcd\u67e5\u627e\u7ecf\u6587'
                    : '\u8f93\u5165\u4e00\u53e5\u8bdd\uff0c\u67e5\u627e\u8bed\u4e49\u63a5\u8fd1\u7684\u7ecf\u6587',
                prefixIcon: Icon(
                  _mode == SearchMode.keyword
                      ? Icons.search_rounded
                      : Icons.auto_awesome_rounded,
                ),
                suffixIcon: IconButton(
                  tooltip: '\u641c\u7d22',
                  onPressed: () => _scheduleSearch(immediate: true),
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
              ),
              onChanged: (_) {
                if (_mode == SearchMode.keyword) {
                  _scheduleSearch();
                }
              },
              onSubmitted: (_) => _scheduleSearch(immediate: true),
            ),
            if (_mode == SearchMode.semantic && !semanticAvailable) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '\u5f53\u524d\u8bd1\u672c\u6ca1\u6709\u5185\u7f6e\u8bed\u4e49\u7d22\u5f15\uff0c\u6682\u65f6\u65e0\u6cd5\u4f7f\u7528\u8bed\u4e49\u641c\u7d22\u3002',
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: _SearchResultsBody(
                mode: _mode,
                query: _query,
                semanticAvailable: semanticAvailable,
                results: results,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleSearch({bool immediate = false}) {
    _debounce?.cancel();
    if (immediate) {
      setState(() {
        _query = _controller.text;
      });
      return;
    }

    if (_mode == SearchMode.semantic) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _query = _controller.text;
      });
    });
  }
}

class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({
    required this.mode,
    required this.query,
    required this.semanticAvailable,
    required this.results,
  });

  final SearchMode mode;
  final String query;
  final bool semanticAvailable;
  final AsyncValue<List<SearchHit>> results;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
        child: Text(
          mode == SearchMode.keyword
              ? '\u8f93\u5165\u5173\u952e\u8bcd\u540e\uff0c\u4f1a\u6309\u7ecf\u6587\u5185\u5bb9\u5339\u914d\u7ed3\u679c\u3002'
              : '\u8f93\u5165\u4e00\u53e5\u8bdd\u540e\uff0c\u4f1a\u8fd4\u56de\u8bed\u4e49\u6700\u63a5\u8fd1\u7684\u7ecf\u6587\u7ed3\u679c\u3002',
        ),
      );
    }

    if (mode == SearchMode.semantic && !semanticAvailable) {
      return const SizedBox.shrink();
    }

    return results.when(
      data: (items) => SearchResultsList(items: items),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          mode == SearchMode.semantic
              ? semanticSearchErrorMessage(error)
              : '\u641c\u7d22\u5931\u8d25\uff1a${error.toString()}',
        ),
      ),
    );
  }
}
