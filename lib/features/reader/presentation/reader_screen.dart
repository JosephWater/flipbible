import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/app_providers.dart';
import '../../../core/models/bible_location.dart';
import '../../../core/models/book_summary.dart';
import '../../../core/models/chapter_content.dart';
import '../../../core/models/copy_settings.dart';
import '../../../core/models/recent_location_entry.dart';
import '../application/verse_copy_formatter.dart';
import 'recent_locations_bar.dart';
import 'water_drop_slider.dart';

enum _ReaderChromeAction {
  toggleSlider,
  toggleRecent,
}

const _paperFlattenCurve = Cubic(0.18, 0.72, 0.16, 1);

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;
  bool _sliderActive = false;
  bool _sliderVisible = true;
  bool _recentBarVisible = true;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..value = 0.42;
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(appBootstrapProvider);
    final settings = ref.watch(readerSettingsProvider);
    final location = ref.watch(currentLocationProvider);
    final currentLocation = location.asData?.value;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _ReaderTitle(location: currentLocation),
        actions: [
          IconButton(
            tooltip: '目录跳转',
            onPressed: currentLocation == null
                ? null
                : () => _showDirectoryPicker(context, currentLocation),
            icon: const Icon(Icons.menu_book_rounded),
          ),
          IconButton(
            tooltip: '搜索',
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: '书库',
            onPressed: () => context.push('/library'),
            icon: const Icon(Icons.library_books_outlined),
          ),
          PopupMenuButton<_ReaderChromeAction>(
            tooltip: '阅读视图',
            onSelected: _handleChromeAction,
            icon: const Icon(Icons.visibility_outlined),
            itemBuilder: (context) => [
              PopupMenuItem<_ReaderChromeAction>(
                value: _ReaderChromeAction.toggleSlider,
                child: Text(_sliderVisible ? '收起翻阅滑块' : '显示翻阅滑块'),
              ),
              PopupMenuItem<_ReaderChromeAction>(
                value: _ReaderChromeAction.toggleRecent,
                child: Text(_recentBarVisible ? '收起主动书签' : '显示主动书签'),
              ),
            ],
          ),
          IconButton(
            tooltip: '设置',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface.withValues(alpha: 0.995),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor.withValues(alpha: 0.975),
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _ambientController,
          builder: (context, child) {
            final drift = Curves.easeInOut.transform(_ambientController.value);
            return Stack(
              children: [
                Positioned(
                  top: -36 + drift * 18,
                  left: -42 + drift * 20,
                  child: _PaperGlow(
                    size: 190,
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  ),
                ),
                Positioned(
                  top: 180 - drift * 24,
                  right: -28,
                  child: _PaperGlow(
                    size: 156,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.048),
                  ),
                ),
                Positioned(
                  bottom: 92 + drift * 18,
                  left: 34,
                  child: _PaperGlow(
                    size: 136,
                    color: theme.colorScheme.primary.withValues(alpha: 0.035),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.14 + drift * 0.08, -0.9),
                        radius: 1.22,
                        colors: [
                          Colors.white.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: bootstrap.when(
                    data: (_) {
                      if (currentLocation == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final booksAsync =
                          ref.watch(booksProvider(currentLocation.translationId));
                      final readerSettings = settings.asData?.value;

                      return booksAsync.when(
                        data: (books) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 1,
                              end: _sliderVisible ? 1 : 0,
                            ),
                            duration: const Duration(milliseconds: 760),
                            curve: _paperFlattenCurve,
                            builder: (context, sliderVisibility, child) {
                              final pageHorizontalPadding =
                                  readerSettings?.pageHorizontalPadding ?? 18;
                              final rightInset =
                                  pageHorizontalPadding + 12 + 70 * sliderVisibility;
                              final sliderWidthFactor =
                                  sliderVisibility.clamp(0.001, 1).toDouble();
                              final sliderScaleX =
                                  0.06 + 0.94 * sliderVisibility;
                              final sliderScaleY = 0.985 + 0.015 * sliderVisibility;
                              final sliderOffset = 48 * (1 - sliderVisibility);

                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: _ReaderPager(
                                          books: books,
                                          currentLocation: currentLocation,
                                          lineHeight:
                                              readerSettings?.lineHeight ?? 1.75,
                                          verseSpacing:
                                              readerSettings?.verseSpacing ?? 10,
                                          fontScale:
                                              readerSettings?.fontScale ?? 1,
                                          horizontalPadding:
                                              pageHorizontalPadding,
                                          scrollLocked: _sliderActive,
                                          rightInset: rightInset,
                                        ),
                                      ),
                                      _AnimatedRecentBar(
                                        visible: _recentBarVisible,
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IgnorePointer(
                                      ignoring: sliderVisibility < 0.92,
                                      child: Opacity(
                                        opacity: Curves.easeOutCubic.transform(
                                          sliderVisibility,
                                        ),
                                        child: ClipRect(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            widthFactor: sliderWidthFactor,
                                            child: Transform.translate(
                                              offset: Offset(sliderOffset, 0),
                                              child: Transform.scale(
                                                alignment: Alignment.centerRight,
                                                scaleX: sliderScaleX,
                                                scaleY: sliderScaleY,
                                                child: WaterDropSlider(
                                                  books: books,
                                                  currentLocation:
                                                      currentLocation,
                                                  onPreviewLocation: (candidate) {
                                                    ref
                                                        .read(
                                                          bibleRepositoryProvider,
                                                        )
                                                        .prefetchChapter(
                                                          candidate,
                                                        );
                                                  },
                                                  onCommit: (selected) async {
                                                    final bookmarkLocation =
                                                        ref.read(
                                                              currentReadingAnchorProvider,
                                                            ) ??
                                                            currentLocation;
                                                    await ref
                                                        .read(
                                                          readerJumpControllerProvider,
                                                        )
                                                        .jumpTo(
                                                          selected,
                                                          source:
                                                              RecentSource.slider,
                                                          bookmarkLocation:
                                                              bookmarkLocation,
                                                        );
                                                    if (mounted) {
                                                      HapticFeedback
                                                          .mediumImpact();
                                                    }
                                                  },
                                                  onInteractionChanged: (active) {
                                                    if (_sliderActive == active) {
                                                      return;
                                                    }
                                                    setState(
                                                      () => _sliderActive = active,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text('书卷目录加载失败：$error'),
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('初始化失败：$error'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDirectoryPicker(
    BuildContext context,
    BibleLocation currentLocation,
  ) async {
    final books = await ref.read(booksProvider(currentLocation.translationId).future);
    if (!context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return _DirectorySheet(
          books: books,
          currentLocation: currentLocation,
          onSelected: (location) async {
            Navigator.of(context).pop();
            final bookmarkLocation =
                ref.read(currentReadingAnchorProvider) ?? currentLocation;
            await ref.read(readerJumpControllerProvider).jumpTo(
                  location,
                  source: RecentSource.directory,
                  bookmarkLocation: bookmarkLocation,
                );
          },
        );
      },
    );
  }

  void _handleChromeAction(_ReaderChromeAction action) {
    if (action == _ReaderChromeAction.toggleSlider) {
      setState(() {
        _sliderVisible = !_sliderVisible;
        if (!_sliderVisible) {
          _sliderActive = false;
        }
      });
      return;
    }

    setState(() {
      _recentBarVisible = !_recentBarVisible;
    });
  }
}

class _AnimatedRecentBar extends StatelessWidget {
  const _AnimatedRecentBar({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: visible ? 1 : 0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubicEmphasized,
      child: const RecentLocationsBar(),
      builder: (context, progress, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: progress.clamp(0.001, 1).toDouble(),
            child: IgnorePointer(
              ignoring: progress < 0.92,
              child: Opacity(
                opacity: Curves.easeOutCubic.transform(progress),
                child: Transform.translate(
                  offset: Offset(0, 22 * (1 - progress)),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReaderPager extends ConsumerStatefulWidget {
  const _ReaderPager({
    required this.books,
    required this.currentLocation,
    required this.lineHeight,
    required this.verseSpacing,
    required this.fontScale,
    required this.horizontalPadding,
    required this.scrollLocked,
    required this.rightInset,
  });

  final List<BookSummary> books;
  final BibleLocation currentLocation;
  final double lineHeight;
  final double verseSpacing;
  final double fontScale;
  final double horizontalPadding;
  final bool scrollLocked;
  final double rightInset;

  @override
  ConsumerState<_ReaderPager> createState() => _ReaderPagerState();
}

class _ReaderPagerState extends ConsumerState<_ReaderPager> {
  late final PageController _pageController;
  int _visiblePageIndex = 0;
  String? _lastPrefetchSignature;

  @override
  void initState() {
    super.initState();
    final initialIndex = _chapterIndexForLocation(widget.currentLocation);
    _visiblePageIndex = initialIndex;
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void didUpdateWidget(covariant _ReaderPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final targetIndex = _chapterIndexForLocation(widget.currentLocation);
    if (_visiblePageIndex != targetIndex) {
      _visiblePageIndex = targetIndex;
    }
    if (_pageController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) {
          return;
        }
        if ((_pageController.page ?? targetIndex.toDouble()).round() !=
            targetIndex) {
          _pageController.jumpToPage(targetIndex);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapters = _chapterReferences(
      widget.books,
      widget.currentLocation.translationId,
    );
    final currentIndex = _chapterIndexForLocation(widget.currentLocation);
    _prefetchChapters(chapters, currentIndex);

    return RepaintBoundary(
      child: PageView.builder(
        controller: _pageController,
        physics: widget.scrollLocked
            ? const NeverScrollableScrollPhysics()
            : const _PaperPageScrollPhysics(parent: BouncingScrollPhysics()),
        allowImplicitScrolling: true,
        itemCount: chapters.length,
        onPageChanged: (index) => _handlePageChanged(index, chapters),
        itemBuilder: (context, index) {
          final location = chapters[index];
          return RepaintBoundary(
            child: _ReaderChapterPage(
              key: ValueKey(
                '${location.translationId}-${location.bookId}-${location.chapter}-$index',
              ),
              location: location,
              lineHeight: widget.lineHeight,
              verseSpacing: widget.verseSpacing,
              fontScale: widget.fontScale,
              horizontalPadding: widget.horizontalPadding,
              highlightVerse: index == currentIndex
                  ? widget.currentLocation.verseStart
                  : null,
              isCurrentPage: index == _visiblePageIndex,
              scrollLocked: widget.scrollLocked,
              rightInset: widget.rightInset,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handlePageChanged(
    int index,
    List<BibleLocation> chapters,
  ) async {
    if (_visiblePageIndex != index && mounted) {
      setState(() {
        _visiblePageIndex = index;
      });
    }

    final target = chapters[index];
    if (target.bookId == widget.currentLocation.bookId &&
        target.chapter == widget.currentLocation.chapter) {
      return;
    }

    ref.read(readerJumpControllerProvider).jumpTo(
      target,
      source: RecentSource.directory,
      recordRecent: false,
      updateReadingAnchor: false,
    );
  }

  void _prefetchChapters(List<BibleLocation> chapters, int currentIndex) {
    if (chapters.isEmpty || currentIndex < 0 || currentIndex >= chapters.length) {
      return;
    }

    final previous = currentIndex > 0 ? chapters[currentIndex - 1] : null;
    final current = chapters[currentIndex];
    final next =
        currentIndex < chapters.length - 1 ? chapters[currentIndex + 1] : null;
    final signature =
        '${previous?.bookId}-${previous?.chapter}|${current.bookId}-${current.chapter}|${next?.bookId}-${next?.chapter}';
    if (_lastPrefetchSignature == signature) {
      return;
    }
    _lastPrefetchSignature = signature;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      final repository = ref.read(bibleRepositoryProvider);
      await repository.prefetchChapter(current);
      if (previous != null) {
        await repository.prefetchChapter(previous);
      }
      if (next != null) {
        await repository.prefetchChapter(next);
      }
    });
  }

  int _chapterIndexForLocation(BibleLocation location) {
    var offset = 0;
    for (final book in widget.books) {
      if (book.id == location.bookId) {
        final chapter = location.chapter.clamp(1, book.chapterCount);
        return offset + chapter - 1;
      }
      offset += book.chapterCount;
    }
    return 0;
  }

  List<BibleLocation> _chapterReferences(
    List<BookSummary> books,
    String translationId,
  ) {
    final chapters = <BibleLocation>[];
    for (final book in books) {
      for (var chapter = 1; chapter <= book.chapterCount; chapter++) {
        chapters.add(
          BibleLocation(
            translationId: translationId,
            bookId: book.id,
            chapter: chapter,
          ),
        );
      }
    }
    return chapters;
  }
}

class _ReaderChapterPage extends ConsumerStatefulWidget {
  const _ReaderChapterPage({
    super.key,
    required this.location,
    required this.lineHeight,
    required this.verseSpacing,
    required this.fontScale,
    required this.horizontalPadding,
    required this.highlightVerse,
    required this.isCurrentPage,
    required this.scrollLocked,
    required this.rightInset,
  });

  final BibleLocation location;
  final double lineHeight;
  final double verseSpacing;
  final double fontScale;
  final double horizontalPadding;
  final int? highlightVerse;
  final bool isCurrentPage;
  final bool scrollLocked;
  final double rightInset;

  @override
  ConsumerState<_ReaderChapterPage> createState() => _ReaderChapterPageState();
}

class _ReaderChapterPageState extends ConsumerState<_ReaderChapterPage> {
  final Object _anchorCaptureOwner = Object();
  final GlobalKey _bodyKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _verseKeys = <int, GlobalKey>{};
  final Set<int> _selectedVerses = <int>{};
  ChapterContent? _currentChapter;
  String? _lastHighlightSignature;
  String? _lastChapterSignature;

  @override
  void initState() {
    super.initState();
    _syncAnchorCaptureRegistration();
  }

  @override
  void didUpdateWidget(covariant _ReaderChapterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextSignature = _chapterSignature(widget.location);
    final previousSignature = _chapterSignature(oldWidget.location);
    if (nextSignature != previousSignature ||
        (oldWidget.isCurrentPage && !widget.isCurrentPage)) {
      _selectedVerses.clear();
    }
    if (oldWidget.isCurrentPage != widget.isCurrentPage) {
      _syncAnchorCaptureRegistration();
    }
  }

  @override
  void dispose() {
    ref.read(readingAnchorCaptureProvider.notifier).unregister(_anchorCaptureOwner);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapterAsync = ref.watch(chapterContentProvider(widget.location));
    return chapterAsync.when(
      data: (chapter) {
        _currentChapter = chapter;
        if (widget.isCurrentPage) {
          _syncScrollPosition();
        }
        final selectionMode = widget.isCurrentPage && _selectedVerses.isNotEmpty;

        return Stack(
          children: [
            RepaintBoundary(
              child: _ReaderBody(
                listKey: _bodyKey,
                scrollController: _scrollController,
                chapter: chapter,
                lineHeight: widget.lineHeight,
                verseSpacing: widget.verseSpacing,
                fontScale: widget.fontScale,
                horizontalPadding: widget.horizontalPadding,
                highlightVerse: widget.highlightVerse,
                verseKeys: _verseKeys,
                scrollLocked: widget.scrollLocked,
                rightInset: widget.rightInset,
                selectionMode: selectionMode,
                selectedVerses: _selectedVerses,
                onVerseLongPress: _enterSelectionMode,
                onVerseTap: selectionMode ? _toggleVerseSelection : null,
              ),
            ),
            if (selectionMode)
              Positioned(
                left: 18,
                right: 18,
                bottom: 16,
                child: _VerseSelectionBar(
                  selectionCount: _selectedVerses.length,
                  onCancel: _clearSelection,
                  onCopy: () => _copySelectedVerses(chapter),
                  onSemanticSearch:
                      _selectedVerses.length == 1 ? _showSimilarVerses : null,
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('章节内容加载失败：$error'),
        ),
      ),
    );
  }

  void _enterSelectionMode(int verse) {
    setState(() {
      _selectedVerses
        ..clear()
        ..add(verse);
    });
    HapticFeedback.selectionClick();
  }

  void _toggleVerseSelection(int verse) {
    setState(() {
      if (_selectedVerses.contains(verse)) {
        _selectedVerses.remove(verse);
      } else {
        _selectedVerses.add(verse);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _clearSelection() {
    if (_selectedVerses.isEmpty) {
      return;
    }
    setState(_selectedVerses.clear);
  }

  Future<void> _copySelectedVerses(ChapterContent chapter) async {
    final copySettings =
        ref.read(copySettingsProvider).asData?.value ??
        const CopySettings.defaults();
    final text = formatSelectedVersesForCopy(
      chapter: chapter,
      selectedVerses: _selectedVerses.toList(),
      settings: copySettings,
    );
    if (text.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }

    _clearSelection();
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制所选经文'),
        duration: Duration(milliseconds: 1600),
      ),
    );
  }

  void _showSimilarVerses() {
    if (_selectedVerses.length != 1) {
      return;
    }
    final selectedVerse = _selectedVerses.first;
    final location = widget.location.copyWith(
      verseStart: selectedVerse,
      clearVerseEnd: true,
    );
    context.push('/similar', extra: location);
  }

  void _syncScrollPosition() {
    final chapterSignature = _chapterSignature(widget.location);
    final verse = widget.highlightVerse;
    if (verse == null) {
      _lastHighlightSignature = null;
      if (_lastChapterSignature == chapterSignature) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) {
          return;
        }
        _scrollController.jumpTo(0);
        _lastChapterSignature = chapterSignature;
      });
      return;
    }

    final signature = '$chapterSignature-$verse';
    if (_lastHighlightSignature == signature) {
      return;
    }
    _ensureVisibleVerse(verse, signature, chapterSignature);
  }

  void _ensureVisibleVerse(
    int verse,
    String signature,
    String chapterSignature, [
    int attempt = 0,
  ]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final context = _verseKeys[verse]?.currentContext;
      if (context == null) {
        if (attempt < 6) {
          _ensureVisibleVerse(verse, signature, chapterSignature, attempt + 1);
        }
        return;
      }

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 320),
        alignment: 0.16,
        curve: Curves.easeOutCubic,
      );
      _lastHighlightSignature = signature;
      _lastChapterSignature = chapterSignature;
    });
  }

  void _syncAnchorCaptureRegistration() {
    final notifier = ref.read(readingAnchorCaptureProvider.notifier);
    if (widget.isCurrentPage) {
      notifier.register(_anchorCaptureOwner, _captureVisibleAnchorNow);
      return;
    }
    notifier.unregister(_anchorCaptureOwner);
  }

  BibleLocation? _captureVisibleAnchorNow() {
    if (!mounted || !widget.isCurrentPage || _currentChapter == null) {
      return null;
    }

    final bodyContext = _bodyKey.currentContext;
    final bodyBox = bodyContext?.findRenderObject() as RenderBox?;
    if (bodyBox == null) {
      return null;
    }

    final bodyTop = bodyBox.localToGlobal(Offset.zero).dy;
    final targetY = bodyTop + 160;
    int? nearestVerse;
    var nearestDistance = double.infinity;

    for (final entry in _verseKeys.entries) {
      final verseBox =
          entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (verseBox == null) {
        continue;
      }

      final verseTop = verseBox.localToGlobal(Offset.zero).dy;
      final distance = (verseTop - targetY).abs();
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestVerse = entry.key;
      }
    }

    final fallbackVerse =
        widget.highlightVerse ??
        (_currentChapter!.verses.isEmpty ? null : _currentChapter!.verses.first.verse);
    final verse = nearestVerse ?? fallbackVerse;
    if (verse == null) {
      return null;
    }

    final anchor = widget.location.copyWith(
      verseStart: verse,
      clearVerseEnd: true,
    );
    final notifier = ref.read(currentReadingAnchorProvider.notifier);
    if (ref.read(currentReadingAnchorProvider) != anchor) {
      notifier.set(anchor);
    }
    return anchor;
  }

  String _chapterSignature(BibleLocation location) {
    return '${location.translationId}-${location.bookId}-${location.chapter}';
  }
}

class _PaperPageScrollPhysics extends PageScrollPhysics {
  const _PaperPageScrollPhysics({super.parent});

  static const SpringDescription _paperSpring = SpringDescription(
    mass: 1.12,
    stiffness: 108,
    damping: 18.5,
  );

  @override
  _PaperPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _PaperPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => _paperSpring;

  double _getPage(ScrollMetrics position) {
    if (position is PageMetrics) {
      return position.page ?? 0;
    }
    return position.pixels / position.viewportDimension;
  }

  double _getPixels(ScrollMetrics position, double page) {
    if (position is PageMetrics) {
      return page * position.viewportDimension * position.viewportFraction;
    }
    return page * position.viewportDimension;
  }

  double _getTargetPage(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    final page = _getPage(position);
    final pageFloor = page.floorToDouble();
    final pageFraction = page - pageFloor;
    final velocityAbs = velocity.abs();
    final momentum = (velocityAbs / 2400).clamp(0.0, 1.0);
    final forwardTrigger = 0.46 - 0.14 * momentum;
    final backwardTrigger = 0.54 + 0.14 * momentum;

    if (velocity > tolerance.velocity || pageFraction >= backwardTrigger) {
      return page.ceilToDouble();
    }
    if (velocity < -tolerance.velocity || pageFraction <= 1 - forwardTrigger) {
      return page.floorToDouble();
    }
    return page.roundToDouble();
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final outOfRange = (velocity <= 0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0 && position.pixels >= position.maxScrollExtent);
    if (outOfRange) {
      return super.createBallisticSimulation(position, velocity);
    }

    final tolerance = toleranceFor(position);
    final targetPage = _getTargetPage(position, tolerance, velocity);
    final targetPixels = _getPixels(position, targetPage);
    if ((targetPixels - position.pixels).abs() < tolerance.distance) {
      return null;
    }

    final easedVelocity = velocity.sign *
        math.pow(velocity.abs(), 0.9).toDouble() *
        0.55;
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      targetPixels,
      easedVelocity,
      tolerance: tolerance,
    );
  }

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(existingVelocity.abs() * 0.08, 180);
  }
}

class _PaperGlow extends StatelessWidget {
  const _PaperGlow({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _ReaderTitle extends ConsumerWidget {
  const _ReaderTitle({required this.location});

  final BibleLocation? location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (location == null) {
      return const Text('FlipBible');
    }

    final label = ref.watch(locationLabelProvider(location!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('FlipBible'),
        Text(
          label.asData?.value ?? '定位中',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.72),
              ),
        ),
      ],
    );
  }
}

class _ReaderBody extends StatelessWidget {
  const _ReaderBody({
    required this.listKey,
    required this.scrollController,
    required this.chapter,
    required this.lineHeight,
    required this.verseSpacing,
    required this.fontScale,
    required this.horizontalPadding,
    required this.highlightVerse,
    required this.verseKeys,
    required this.scrollLocked,
    required this.rightInset,
    required this.selectionMode,
    required this.selectedVerses,
    required this.onVerseLongPress,
    required this.onVerseTap,
  });

  final GlobalKey listKey;
  final ScrollController scrollController;
  final ChapterContent chapter;
  final double lineHeight;
  final double verseSpacing;
  final double fontScale;
  final double horizontalPadding;
  final int? highlightVerse;
  final Map<int, GlobalKey> verseKeys;
  final bool scrollLocked;
  final double rightInset;
  final bool selectionMode;
  final Set<int> selectedVerses;
  final ValueChanged<int> onVerseLongPress;
  final ValueChanged<int>? onVerseTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final effectiveLineHeight = lineHeight.clamp(1.15, 2.35).toDouble();
    final effectiveFontScale = fontScale.clamp(0.72, 1.7).toDouble();
    final effectiveVerseSpacing = verseSpacing.clamp(-4, 40).toDouble();
    final effectiveHorizontalPadding =
        horizontalPadding.clamp(0, 32).toDouble();
    final openingVerse = chapter.verses.isEmpty ? null : chapter.verses.first;
    final remainingVerses = chapter.verses.length > 1
        ? chapter.verses.sublist(1)
        : const <VerseContent>[];

    return ListView(
      key: listKey,
      controller: scrollController,
      physics: scrollLocked
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        effectiveHorizontalPadding,
        14,
        rightInset,
        selectionMode ? 116 : 32,
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '${chapter.book.name} ${chapter.chapter}',
                style: textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary.withValues(alpha: 0.88),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                  fontSize: 18 * effectiveFontScale,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              chapter.translation.title,
              style: textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary.withValues(alpha: 0.82),
                letterSpacing: 0.22,
                fontSize: 14 * effectiveFontScale,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          height: 1,
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
        const SizedBox(height: 18),
        if (openingVerse != null)
          _OpeningVerseBlock(
            key: verseKeys.putIfAbsent(openingVerse.verse, GlobalKey.new),
            verse: openingVerse,
            isHighlighted: openingVerse.verse == highlightVerse,
            isSelected: selectedVerses.contains(openingVerse.verse),
            selectionMode: selectionMode,
            lineHeight: effectiveLineHeight,
            verseSpacing: effectiveVerseSpacing,
            fontScale: effectiveFontScale,
            onLongPress: () => onVerseLongPress(openingVerse.verse),
            onTap: onVerseTap == null
                ? null
                : () => onVerseTap!(openingVerse.verse),
          )
        else
          Text(
            '这个章节当前还没有正文内容。',
            style: textTheme.bodyLarge?.copyWith(
              height: effectiveLineHeight,
              fontSize: 18 * effectiveFontScale,
            ),
          ),
        if (remainingVerses.isNotEmpty) ...[
          SizedBox(height: math.max(0, effectiveVerseSpacing * 0.25)),
          for (final verse in remainingVerses)
            _InlineVerseBlock(
              key: verseKeys.putIfAbsent(verse.verse, GlobalKey.new),
              verse: verse,
              isHighlighted: verse.verse == highlightVerse,
              isSelected: selectedVerses.contains(verse.verse),
              selectionMode: selectionMode,
              lineHeight: effectiveLineHeight,
              verseSpacing: effectiveVerseSpacing,
              fontScale: effectiveFontScale,
              onLongPress: () => onVerseLongPress(verse.verse),
              onTap: onVerseTap == null ? null : () => onVerseTap!(verse.verse),
            ),
        ],
        const SizedBox(height: 110),
      ],
    );
  }
}

double _verseBlockVerticalInset(
  double verseSpacing, {
  required double maxInset,
}) {
  final normalized = (verseSpacing / 10).clamp(0, 1).toDouble();
  return maxInset * normalized;
}

class _OpeningVerseBlock extends StatelessWidget {
  const _OpeningVerseBlock({
    super.key,
    required this.verse,
    required this.isHighlighted,
    required this.isSelected,
    required this.selectionMode,
    required this.lineHeight,
    required this.verseSpacing,
    required this.fontScale,
    required this.onLongPress,
    required this.onTap,
  });

  final VerseContent verse;
  final bool isHighlighted;
  final bool isSelected;
  final bool selectionMode;
  final double lineHeight;
  final double verseSpacing;
  final double fontScale;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = theme.colorScheme.secondary.withValues(alpha: 0.1);
    final selectionGlow = theme.colorScheme.primary.withValues(alpha: 0.12);
    final verticalInset = _verseBlockVerticalInset(
      verseSpacing,
      maxInset: 8,
    );
    final leadingInset = 6 + 4 * (verticalInset / 8);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: verseSpacing),
        padding: EdgeInsets.fromLTRB(leadingInset, verticalInset, 0, verticalInset),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    selectionGlow,
                    Colors.transparent,
                  ],
                )
              : isHighlighted
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    highlight,
                    Colors.transparent,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.62)
                  : isHighlighted
                  ? theme.colorScheme.secondary.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 2.4,
            ),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          '${verse.verse}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 13 * fontScale,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: verse.text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 19.3 * fontScale,
                        height: lineHeight,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectionMode)
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 18,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InlineVerseBlock extends StatelessWidget {
  const _InlineVerseBlock({
    super.key,
    required this.verse,
    required this.isHighlighted,
    required this.isSelected,
    required this.selectionMode,
    required this.lineHeight,
    required this.verseSpacing,
    required this.fontScale,
    required this.onLongPress,
    required this.onTap,
  });

  final VerseContent verse;
  final bool isHighlighted;
  final bool isSelected;
  final bool selectionMode;
  final double lineHeight;
  final double verseSpacing;
  final double fontScale;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = theme.colorScheme.secondary.withValues(alpha: 0.1);
    final selectionGlow = theme.colorScheme.primary.withValues(alpha: 0.11);
    final verticalInset = _verseBlockVerticalInset(
      verseSpacing,
      maxInset: 6,
    );
    final leadingInset = 6 + 4 * (verticalInset / 6);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: verseSpacing),
        padding: EdgeInsets.fromLTRB(leadingInset, verticalInset, 0, verticalInset),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    selectionGlow,
                    Colors.transparent,
                  ],
                )
              : isHighlighted
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    highlight,
                    Colors.transparent,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.58)
                  : isHighlighted
                  ? theme.colorScheme.secondary.withValues(alpha: 0.45)
                  : Colors.transparent,
              width: 2.2,
            ),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6, top: 3),
                        child: Text(
                          '${verse.verse}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 12 * fontScale,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: verse.text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 19.2 * fontScale,
                        height: lineHeight,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectionMode)
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                child: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 18,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VerseSelectionBar extends StatelessWidget {
  const _VerseSelectionBar({
    required this.selectionCount,
    required this.onCancel,
    required this.onCopy,
    required this.onSemanticSearch,
  });

  final int selectionCount;
  final VoidCallback onCancel;
  final VoidCallback onCopy;
  final VoidCallback? onSemanticSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '\u5df2\u9009 $selectionCount \u8282',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.16),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final semanticButton = onSemanticSearch == null
              ? null
              : OutlinedButton.icon(
                  key: const Key('semantic-search-button'),
                  onPressed: onSemanticSearch,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text('\u76f8\u4f3c\u7ecf\u6587'),
                );

          final actionButtons = <Widget>[
            TextButton(
              onPressed: onCancel,
              child: const Text('\u53d6\u6d88'),
            ),
            ...semanticButton == null
                ? const <Widget>[]
                : <Widget>[semanticButton],
            FilledButton.icon(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_rounded),
              label: const Text('\u590d\u5236'),
            ),
          ];

          if (constraints.maxWidth < 560) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chip,
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: actionButtons,
                ),
              ],
            );
          }

          return Row(
            children: [
              chip,
              const Spacer(),
              TextButton(
                onPressed: onCancel,
                child: const Text('取消'),
              ),
              if (semanticButton != null) ...[
                const SizedBox(width: 8),
                semanticButton,
              ],
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: onCopy,
                icon: const Icon(Icons.copy_rounded),
                label: const Text('复制'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DirectorySheet extends StatefulWidget {
  const _DirectorySheet({
    required this.books,
    required this.currentLocation,
    required this.onSelected,
  });

  final List<BookSummary> books;
  final BibleLocation currentLocation;
  final ValueChanged<BibleLocation> onSelected;

  @override
  State<_DirectorySheet> createState() => _DirectorySheetState();
}

class _DirectorySheetState extends State<_DirectorySheet> {
  late BookSummary _selectedBook;

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.books.firstWhere(
      (book) => book.id == widget.currentLocation.bookId,
      orElse: () => widget.books.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final oldTestament = widget.books.where(_isOldTestament).toList();
    final newTestament = widget.books.where(_isNewTestament).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: Column(
            children: [
              Text(
                '目录跳转',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 11,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.08),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _BookGroupGrid(
                                title: '旧约',
                                books: oldTestament,
                                selectedBookId: _selectedBook.id,
                                onSelected: (book) =>
                                    setState(() => _selectedBook = book),
                              ),
                              const SizedBox(height: 16),
                              _BookGroupGrid(
                                title: '新约',
                                books: newTestament,
                                selectedBookId: _selectedBook.id,
                                onSelected: (book) =>
                                    setState(() => _selectedBook = book),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedBook.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_selectedBook.abbreviation} · 共 ${_selectedBook.chapterCount} 章',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: GridView.builder(
                                  primary: false,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1.3,
                                  ),
                                  itemCount: _selectedBook.chapterCount,
                                  itemBuilder: (context, index) {
                                    final chapter = index + 1;
                                    final selected =
                                        chapter == widget.currentLocation.chapter &&
                                            _selectedBook.id ==
                                                widget.currentLocation.bookId;
                                    return _ChapterGridTile(
                                      chapter: chapter,
                                      selected: selected,
                                      onTap: () => widget.onSelected(
                                        BibleLocation(
                                          translationId:
                                              widget.currentLocation.translationId,
                                          bookId: _selectedBook.id,
                                          chapter: chapter,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookGroupGrid extends StatelessWidget {
  const _BookGroupGrid({
    required this.title,
    required this.books,
    required this.selectedBookId,
    required this.onSelected,
  });

  final String title;
  final List<BookSummary> books;
  final int selectedBookId;
  final ValueChanged<BookSummary> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.55,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _BookGridTile(
              book: book,
              selected: book.id == selectedBookId,
              onTap: () => onSelected(book),
            );
          },
        ),
      ],
    );
  }
}

class _BookGridTile extends StatelessWidget {
  const _BookGridTile({
    required this.book,
    required this.selected,
    required this.onTap,
  });

  final BookSummary book;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : theme.colorScheme.surface.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.32)
                : theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          book.abbreviation.isNotEmpty ? book.abbreviation : book.name,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ChapterGridTile extends StatelessWidget {
  const _ChapterGridTile({
    required this.chapter,
    required this.selected,
    required this.onTap,
  });

  final int chapter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.14)
            : theme.colorScheme.surface,
        foregroundColor: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
        side: BorderSide(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: onTap,
      child: Text('$chapter'),
    );
  }
}

bool _isNewTestament(BookSummary book) {
  final value = book.testament.toLowerCase();
  return value.contains('new') || value == 'nt';
}

bool _isOldTestament(BookSummary book) {
  return !_isNewTestament(book);
}
