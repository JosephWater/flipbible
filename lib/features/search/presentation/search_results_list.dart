import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_providers.dart';
import '../../../core/data/semantic_embedding_client.dart';
import '../../../core/models/recent_location_entry.dart';
import '../../../core/models/search_hit.dart';

class SearchResultsList extends ConsumerWidget {
  const SearchResultsList({
    super.key,
    required this.items,
    this.emptyMessage = '\u6ca1\u6709\u627e\u5230\u7ed3\u679c',
  });

  final List<SearchHit> items;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final hit = items[index];
        final verse = hit.location.verseStart;
        final title = verse == null
            ? '${hit.bookName} ${hit.location.chapter}'
            : '${hit.bookName} ${hit.location.chapter}:$verse';

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(title),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(hit.snippet),
            ),
            trailing: const Icon(Icons.north_west_rounded),
            onTap: () async {
              final bookmarkLocation = ref.read(currentReadingAnchorProvider) ??
                  ref.read(currentLocationProvider).asData?.value;
              await ref.read(readerJumpControllerProvider).jumpTo(
                    hit.location,
                    source: RecentSource.search,
                    bookmarkLocation: bookmarkLocation,
                  );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        );
      },
    );
  }
}

String semanticSearchErrorMessage(Object error) {
  if (error is! SemanticSearchException) {
    return '\u641c\u7d22\u5931\u8d25\uff1a${error.toString()}';
  }

  switch (error.type) {
    case SemanticSearchErrorType.missingConfiguration:
      return '\u8bf7\u5148\u5728\u8bbe\u7f6e\u4e2d\u5b8c\u6210\u8bed\u4e49\u641c\u7d22\u6388\u6743\uff0c\u6216\u586b\u5199\u53ef\u7528\u7684 API Key\u3002';
    case SemanticSearchErrorType.unsupportedTranslation:
      return '\u5f53\u524d\u8bd1\u672c\u4e0d\u652f\u6301\u8bed\u4e49\u641c\u7d22\u3002';
    case SemanticSearchErrorType.unauthorized:
      return _semanticErrorWithDetails(
        fallback:
            '\u8bed\u4e49\u641c\u7d22\u9274\u6743\u5931\u8d25\uff0c\u8bf7\u68c0\u67e5\u6388\u6743\u72b6\u6001\u6216 API Key\u3002',
        details: error.message,
      );
    case SemanticSearchErrorType.rateLimited:
      return _semanticErrorWithDetails(
        fallback:
            '\u8bed\u4e49\u641c\u7d22\u8bf7\u6c42\u8fc7\u4e8e\u9891\u7e41\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\u3002',
        details: error.message,
      );
    case SemanticSearchErrorType.requestRejected:
      return _semanticErrorWithDetails(
        fallback:
            '\u8bed\u4e49\u641c\u7d22\u8bf7\u6c42\u88ab\u670d\u52a1\u62d2\u7edd\uff0c\u8bf7\u68c0\u67e5 Base URL\u3001\u6a21\u578b\u6216 API Key \u914d\u7f6e\u3002',
        details: error.message,
      );
    case SemanticSearchErrorType.network:
      return _semanticErrorWithDetails(
        fallback:
            '\u65e0\u6cd5\u8fde\u63a5\u8bed\u4e49\u641c\u7d22\u670d\u52a1\uff0c\u8bf7\u68c0\u67e5\u7f51\u7edc\u6216\u670d\u52a1\u5730\u5740\u3002',
        details: error.message,
      );
    case SemanticSearchErrorType.timeout:
      return _semanticErrorWithDetails(
        fallback:
            '\u8bed\u4e49\u641c\u7d22\u670d\u52a1\u54cd\u5e94\u8d85\u65f6\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\u3002',
        details: error.message,
      );
    case SemanticSearchErrorType.invalidResponse:
      return _semanticErrorWithDetails(
        fallback:
            '\u8bed\u4e49\u641c\u7d22\u670d\u52a1\u8fd4\u56de\u7684\u6570\u636e\u65e0\u6cd5\u89e3\u6790\u3002',
        details: error.message,
      );
  }
}

String _semanticErrorWithDetails({
  required String fallback,
  required String? details,
}) {
  final cleaned = details?.trim() ?? '';
  if (cleaned.isEmpty) {
    return fallback;
  }
  return '$fallback\n$cleaned';
}
