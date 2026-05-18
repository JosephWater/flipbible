import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_providers.dart';
import '../../../core/models/recent_location_entry.dart';

class RecentLocationsBar extends ConsumerWidget {
  const RecentLocationsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recentLocationsProvider);
    final controller = ref.read(readerJumpControllerProvider);

    return Container(
      key: const Key('recent-locations-bar'),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '主动书签',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    ref.read(recentLocationRepositoryProvider).clearRecent(),
                child: const Text('清空最近'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          items.when(
            data: (entries) {
              if (entries.isEmpty) {
                return Text(
                  '每次显式跳转前的位置会自动留在这里，方便你直接回到刚才离开的那一节。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.72),
                      ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final entry in entries)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Consumer(
                          builder: (context, ref, _) {
                            final label =
                                ref.watch(locationLabelProvider(entry.location));
                            return GestureDetector(
                              onLongPressStart: (details) => _showRecentMenu(
                                context,
                                ref,
                                entry,
                                details.globalPosition,
                              ),
                              child: ActionChip(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withValues(alpha: 0.74),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.28),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                label: Text(label.asData?.value ?? '定位中'),
                                onPressed: () => controller.jumpTo(
                                  entry.location,
                                  source: RecentSource.recent,
                                  bookmarkLocation:
                                      ref.read(currentReadingAnchorProvider) ??
                                      ref.read(currentLocationProvider).asData?.value ??
                                      entry.location,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
            loading: () => const LinearProgressIndicator(minHeight: 2),
            error: (error, stackTrace) => Text('最近位置加载失败：$error'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRecentMenu(
    BuildContext context,
    WidgetRef ref,
    RecentLocationEntry entry,
    Offset globalPosition,
  ) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) {
      return;
    }

    final action = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromCircle(center: globalPosition, radius: 1),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem<String>(
          value: 'archive',
          child: Text('归档'),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text('删除'),
        ),
      ],
    );

    if (action == 'archive') {
      await ref.read(recentLocationRepositoryProvider).archive(entry.id);
    } else if (action == 'delete') {
      await ref.read(recentLocationRepositoryProvider).delete(entry.id);
    }
  }
}
