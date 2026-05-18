import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show FontFeature, lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/bible_location.dart';
import '../../../core/models/book_summary.dart';

enum SliderLayer {
  book,
  chapter,
}

class WaterDropSlider extends StatefulWidget {
  const WaterDropSlider({
    super.key,
    required this.books,
    required this.currentLocation,
    required this.onCommit,
    this.onPreviewLocation,
    this.onInteractionChanged,
  });

  final List<BookSummary> books;
  final BibleLocation currentLocation;
  final ValueChanged<BibleLocation> onCommit;
  final ValueChanged<BibleLocation>? onPreviewLocation;
  final ValueChanged<bool>? onInteractionChanged;

  @override
  State<WaterDropSlider> createState() => _WaterDropSliderState();
}

class _WaterDropSliderState extends State<WaterDropSlider>
    with TickerProviderStateMixin {
  static const double _widgetWidth = 206;
  static const double _bookHandleWidth = 62;
  static const double _chapterHandleWidth = 44;
  static const double _idleBookHandleHeight = 122;
  static const double _activeBookHandleHeight = 184;
  static const double _idleChapterHandleHeight = 82;
  static const double _activeChapterHandleHeight = 138;
  static const double _safeTop = 84;
  static const double _safeBottom = 84;
  static const double _minimumIdleGap = 92;
  static const double _wheelGap = 38;
  static const int _visibleRange = 4;
  static const double _holdSlop = 12;
  static const double _bookLockThreshold = 8;
  static const double _chapterSwitchThreshold = 34;
  static const double _chapterTriggerInset = 68;
  static const double _bookUnlockThreshold = 12;
  static const double _softLockedBookDragResistance = 0.72;
  static const Duration _holdDuration = Duration(milliseconds: 220);

  late final AnimationController _activeController;
  late final AnimationController _holdController;

  bool _isActive = false;
  bool _holdPending = false;
  bool _bookSelectionFrozen = false;
  bool _bookLocked = false;
  bool _chapterEngaging = false;
  SliderLayer _layer = SliderLayer.book;

  late int _selectedBookIndex;
  late int _selectedChapter;
  double _bookFocus = 0;
  double _chapterFocus = 0;
  double _bookHandleY = 0;
  double _chapterHandleY = 0;

  int? _trackingPointer;
  Offset? _pointerDownPosition;
  Offset? _latestPointerPosition;
  SliderLayer? _pendingLayer;
  Timer? _holdTimer;
  double? _chapterRangeAnchorY;
  int? _chapterRangeAnchorChapter;
  double? _bookLockDx;
  bool _commitAfterChapterEngage = false;
  _TrackBounds? _latestTrackBounds;
  String? _lastPreviewSignature;

  @override
  void initState() {
    super.initState();
    _activeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _holdController = AnimationController(
      vsync: this,
      duration: _holdDuration,
    );
    _syncWithLocation();
  }

  @override
  void didUpdateWidget(covariant WaterDropSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isActive && !_holdPending) {
      _syncWithLocation();
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _activeController.dispose();
    _holdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return const SizedBox(width: _widgetWidth);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(_widgetWidth, constraints.maxHeight);
        final track = _trackBounds(size.height);
        _latestTrackBounds = track;
        final idleAnchors = _resolveIdleAnchors(track, avoidOverlap: true);
        final displayBookY = _isActive ? _bookHandleY : idleAnchors.bookY;
        final displayChapterY = _isActive ? _chapterHandleY : idleAnchors.chapterY;
        final pendingProgress = _holdPending ? _holdController.value : 0.0;

        return SizedBox(
          width: _widgetWidth,
          height: constraints.maxHeight,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) =>
                _handlePointerDown(event, size, track, idleAnchors),
            onPointerMove: (event) => _handlePointerMove(event, size, track),
            onPointerUp: _handlePointerUp,
            onPointerCancel: _handlePointerCancel,
            child: AnimatedBuilder(
              animation: Listenable.merge([_activeController, _holdController]),
              builder: (context, child) {
                final activeT = Curves.easeOutCubic.transform(
                  _activeController.value,
                );
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (_isActive)
                      const Positioned.fill(
                        child: IgnorePointer(
                          child: SizedBox(key: Key('slider-overlay')),
                        ),
                      ),
                    if (_isActive && _layer == SliderLayer.book)
                      _buildBookWheel(context, displayBookY),
                    if (_isActive && _layer == SliderLayer.chapter) ...[
                      _buildSelectedBookText(context, displayBookY),
                      _buildChapterWheel(context, displayChapterY),
                    ],
                    _buildBookHandle(
                      context,
                      activeT,
                      displayBookY,
                      pendingProgress: _pendingLayer == SliderLayer.book
                          ? pendingProgress
                          : 0,
                    ),
                    _buildChapterHandle(
                      context,
                      activeT,
                      displayChapterY,
                      pendingProgress: _pendingLayer == SliderLayer.chapter
                          ? pendingProgress
                          : 0,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookHandle(
    BuildContext context,
    double activeT,
    double displayY, {
    required double pendingProgress,
  }) {
    final height =
        lerpDouble(_idleBookHandleHeight, _activeBookHandleHeight, activeT) ??
            _idleBookHandleHeight;

    return AnimatedPositioned(
      duration: _bookHandleDuration,
      curve: _bookHandleCurve,
      top: displayY - height / 2,
      right: 0,
      child: _HandleShell(
        key: const Key('book-handle'),
        width: _bookHandleWidth,
        height: height,
        active: _isActive && _layer == SliderLayer.book,
        label: '卷',
        value: widget.books[_selectedBookIndex].abbreviation,
        holdProgress: pendingProgress,
      ),
    );
  }

  Widget _buildChapterHandle(
    BuildContext context,
    double activeT,
    double displayY, {
    required double pendingProgress,
  }) {
    final height =
        lerpDouble(
              _idleChapterHandleHeight,
              _activeChapterHandleHeight,
              activeT,
            ) ??
            _idleChapterHandleHeight;

    return AnimatedPositioned(
      duration: _chapterHandleDuration,
      curve: _chapterHandleCurve,
      onEnd: _handleChapterHandleAnimationEnd,
      top: displayY - height / 2,
      right: 0,
      child: _HandleShell(
        key: const Key('chapter-handle'),
        width: _chapterHandleWidth,
        height: height,
        active: _isActive && _layer == SliderLayer.chapter,
        label: '章',
        value: '$_selectedChapter',
        holdProgress: pendingProgress,
      ),
    );
  }

  Widget _buildBookWheel(BuildContext context, double centerY) {
    final visible = _visibleIndexes(widget.books.length, _bookFocus);
    return Stack(
      children: [
        for (final index in visible)
          _BookWheelItem(
            key: ValueKey('book-item-$index'),
            book: widget.books[index],
            isSelected: index == _selectedBookIndex,
            locked: _bookLocked && index == _selectedBookIndex,
            distance: index - _bookFocus,
            centerY: centerY,
          ),
      ],
    );
  }

  Widget _buildSelectedBookText(BuildContext context, double centerY) {
    final theme = Theme.of(context);
    final book = widget.books[_selectedBookIndex];
    return Positioned(
      top: centerY - 36,
      right: 98,
      child: IgnorePointer(
        child: Opacity(
          opacity: Curves.easeOutCubic.transform(_activeController.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                book.abbreviation,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                book.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterWheel(BuildContext context, double centerY) {
    final chapterCount = widget.books[_selectedBookIndex].chapterCount;
    final visible = _visibleIndexes(chapterCount, _chapterFocus);
    return Stack(
      children: [
        for (final index in visible)
          _ChapterWheelItem(
            key: ValueKey('chapter-item-$index'),
            chapter: index + 1,
            isSelected: index + 1 == _selectedChapter,
            distance: index - _chapterFocus,
            centerY: centerY,
          ),
      ],
    );
  }

  void _handlePointerDown(
    PointerDownEvent event,
    Size size,
    _TrackBounds track,
    _AnchorPair idleAnchors,
  ) {
    if (_isActive || _holdPending || widget.books.isEmpty) {
      return;
    }

    final layer = _resolveHitLayer(event.localPosition, size, idleAnchors);
    if (layer == null) {
      return;
    }

    _trackingPointer = event.pointer;
    _pointerDownPosition = event.localPosition;
    _latestPointerPosition = event.localPosition;
    _pendingLayer = layer;
    _holdPending = true;
    _holdController.forward(from: 0);
    _holdTimer?.cancel();
    _holdTimer = Timer(_holdDuration, () {
      if (!mounted || !_holdPending || _trackingPointer != event.pointer) {
        return;
      }
      _activateInteraction(track, idleAnchors);
    });
    setState(() {});
  }

  void _handlePointerMove(
    PointerMoveEvent event,
    Size size,
    _TrackBounds track,
  ) {
    if (_trackingPointer != event.pointer) {
      return;
    }

    _latestPointerPosition = event.localPosition;

    if (_holdPending) {
      final origin = _pointerDownPosition;
      if (origin != null &&
          (event.localPosition - origin).distance > _holdSlop) {
        _clearPendingHold();
      }
      return;
    }

    if (!_isActive) {
      return;
    }

    final localPosition = event.localPosition;
    final origin = _pointerDownPosition ?? localPosition;
    final dragY = localPosition.dy - origin.dy;
    final leftPull = origin.dx - localPosition.dx;

    if (_layer == SliderLayer.book) {
      final rawBookY = _softClampY(localPosition.dy, track);
      final lockedCenterY = _focusToTrackY(
        _bookFocus,
        track,
        widget.books.length,
      );
      final effectiveBookY =
          _bookLocked
              ? (lerpDouble(
                    lockedCenterY,
                    rawBookY,
                    _softLockedBookDragResistance,
                  ) ??
                  rawBookY)
              : rawBookY;
      final snappedBookY = _applyBookSelection(effectiveBookY, track);
      final snappedSelectedBookY = _focusToTrackY(
        _selectedBookIndex.toDouble(),
        track,
        widget.books.length,
      );
      final touchesSelectedBookLabel = _selectedBookLabelRect(
        size,
        snappedSelectedBookY,
      ).inflate(10).contains(localPosition);
      final shouldLockBook =
          leftPull > _bookLockThreshold && touchesSelectedBookLabel;
      final shouldUnlockBook =
          _bookLocked &&
          _bookLockDx != null &&
          localPosition.dx - _bookLockDx! > _bookUnlockThreshold;

      if (shouldUnlockBook) {
        setState(() {
          _bookSelectionFrozen = false;
          _bookLocked = false;
          _bookLockDx = null;
          _bookHandleY = snappedBookY;
        });
        return;
      }

      if (shouldLockBook) {
        if (!_bookLocked) {
          HapticFeedback.selectionClick();
        }
        setState(() {
          _bookSelectionFrozen = false;
          _bookLocked = true;
          _bookLockDx ??= localPosition.dx;
          _bookHandleY = snappedBookY;
        });
      } else if (!_bookLocked) {
        setState(() {
          _bookSelectionFrozen = false;
          _bookLockDx = null;
          _bookHandleY = snappedBookY;
        });
        return;
      } else {
        setState(() {
          _bookSelectionFrozen = false;
          _bookHandleY = snappedBookY;
        });
      }

      final reachedChapterZone =
          _bookLocked &&
          leftPull > _chapterSwitchThreshold &&
          (leftPull + 16 > dragY.abs() ||
              leftPull > math.max(12, dragY.abs() * 0.3) ||
              localPosition.dx <= size.width - _chapterTriggerInset);

      if (reachedChapterZone) {
        _enterChapterMode(localPosition, track);
      }
      return;
    }

    _updateChapterSelection(localPosition, track);
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_trackingPointer != event.pointer) {
      return;
    }

    if (_holdPending) {
      _clearPendingHold();
      return;
    }

    if (_isActive) {
      _commitSelection();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_trackingPointer != event.pointer) {
      return;
    }

    if (_holdPending) {
      _clearPendingHold();
      return;
    }

    _cancelInteraction();
  }

  void _activateInteraction(_TrackBounds track, _AnchorPair idleAnchors) {
    final startLayer = _pendingLayer;
    if (startLayer == null) {
      return;
    }

    final localPosition = _latestPointerPosition ?? _pointerDownPosition;
    if (localPosition == null) {
      _clearPendingHold();
      return;
    }

    _holdPending = false;
    _holdTimer?.cancel();
    _commitAfterChapterEngage = false;
    _holdController.reverse();

    setState(() {
      _isActive = true;
      _layer = startLayer;
      _bookSelectionFrozen = startLayer == SliderLayer.chapter;
      _bookLocked = false;
      _chapterEngaging = false;
      _bookLockDx = null;
      _lastPreviewSignature = null;
      _bookHandleY = idleAnchors.bookY;
      _chapterHandleY = idleAnchors.chapterY;

      if (startLayer == SliderLayer.book) {
        _bookHandleY = _applyBookSelection(
          _softClampY(localPosition.dy, track),
          track,
        );
      } else {
        _chapterRangeAnchorY = _chapterHandleY;
        _chapterRangeAnchorChapter = _selectedChapter;
        _chapterHandleY = _applyChapterSelection(
          _softClampY(
            localPosition.dy,
            _chapterSelectionTrack(
              track,
              widget.books[_selectedBookIndex].chapterCount,
              _chapterRangeAnchorY!,
              _chapterRangeAnchorChapter!,
            ),
          ),
          _chapterSelectionTrack(
            track,
            widget.books[_selectedBookIndex].chapterCount,
            _chapterRangeAnchorY!,
            _chapterRangeAnchorChapter!,
          ),
        );
      }
    });

    widget.onInteractionChanged?.call(true);
    HapticFeedback.mediumImpact();
    _activeController.forward();
  }

  void _enterChapterMode(Offset localPosition, _TrackBounds track) {
    if (_layer == SliderLayer.chapter) {
      return;
    }

    final previousChapterY = _chapterHandleY;
    _chapterRangeAnchorY =
        localPosition.dy.clamp(track.min, track.max).toDouble();
    _chapterRangeAnchorChapter = _selectedChapter;
    final chapterTrack = _chapterSelectionTrack(
      track,
      widget.books[_selectedBookIndex].chapterCount,
      _chapterRangeAnchorY!,
      _chapterRangeAnchorChapter!,
    );
    final targetChapterY = _applyChapterSelection(
      _softClampY(localPosition.dy, chapterTrack),
      chapterTrack,
    );

    setState(() {
      _layer = SliderLayer.chapter;
      _bookSelectionFrozen = true;
      _bookLocked = false;
      _chapterEngaging = (targetChapterY - previousChapterY).abs() > 2;
      _bookLockDx = null;
      _bookFocus = _selectedBookIndex.toDouble();
      _bookHandleY = _focusToTrackY(
        _bookFocus,
        track,
        widget.books.length,
      );
      _chapterHandleY = targetChapterY;
    });

    HapticFeedback.mediumImpact();
    _notifyPreview();
  }

  void _updateChapterSelection(Offset localPosition, _TrackBounds track) {
    final anchorY = _chapterRangeAnchorY ?? _chapterHandleY;
    final anchorChapter = _chapterRangeAnchorChapter ?? _selectedChapter;
    final chapterTrack = _chapterSelectionTrack(
      track,
      widget.books[_selectedBookIndex].chapterCount,
      anchorY,
      anchorChapter,
    );
    final snappedChapterY = _applyChapterSelection(
      _softClampY(localPosition.dy, chapterTrack),
      chapterTrack,
    );

    setState(() {
      _chapterHandleY = snappedChapterY;
    });
    _notifyPreview();
  }

  void _commitSelection() {
    if (!_isActive || widget.books.isEmpty) {
      return;
    }

    if (_chapterEngaging) {
      _commitAfterChapterEngage = true;
      return;
    }

    _finalizeCommit();
  }

  void _finalizeCommit() {
    if (!_isActive || widget.books.isEmpty) {
      return;
    }

    final book = widget.books[_selectedBookIndex];
    final nextLocation = BibleLocation(
      translationId: widget.currentLocation.translationId,
      bookId: book.id,
      chapter: _selectedChapter.clamp(1, book.chapterCount).toInt(),
    );

    _clearPointerTracking();
    setState(() {
      _isActive = false;
      _layer = SliderLayer.book;
      _bookSelectionFrozen = false;
      _bookLocked = false;
      _chapterEngaging = false;
      _bookLockDx = null;
      _commitAfterChapterEngage = false;
      _chapterRangeAnchorY = null;
      _chapterRangeAnchorChapter = null;
      _lastPreviewSignature = null;
      _syncWithLocationOverride(nextLocation);
    });

    widget.onInteractionChanged?.call(false);
    _activeController.reverse();
    HapticFeedback.lightImpact();
    widget.onCommit(nextLocation);
  }

  void _cancelInteraction() {
    if (!_isActive) {
      _clearPointerTracking();
      return;
    }

    _clearPointerTracking();
    setState(() {
      _isActive = false;
      _layer = SliderLayer.book;
      _bookSelectionFrozen = false;
      _bookLocked = false;
      _chapterEngaging = false;
      _bookLockDx = null;
      _commitAfterChapterEngage = false;
      _chapterRangeAnchorY = null;
      _chapterRangeAnchorChapter = null;
      _lastPreviewSignature = null;
      _syncWithLocation();
    });

    widget.onInteractionChanged?.call(false);
    _activeController.reverse();
  }

  void _clearPendingHold() {
    _holdTimer?.cancel();
    _holdPending = false;
    _pendingLayer = null;
    _commitAfterChapterEngage = false;
    _lastPreviewSignature = null;
    _holdController.reverse();
    _clearPointerTracking();
    if (mounted) {
      setState(() {});
    }
  }

  void _clearPointerTracking() {
    _trackingPointer = null;
    _pointerDownPosition = null;
    _latestPointerPosition = null;
    _pendingLayer = null;
  }

  SliderLayer? _resolveHitLayer(
    Offset localPosition,
    Size size,
    _AnchorPair idleAnchors,
  ) {
    final bookRect = Rect.fromLTWH(
      size.width - _bookHandleWidth,
      idleAnchors.bookY - _idleBookHandleHeight / 2,
      _bookHandleWidth,
      _idleBookHandleHeight,
    );
    final chapterRect = Rect.fromLTWH(
      size.width - _chapterHandleWidth,
      idleAnchors.chapterY - _idleChapterHandleHeight / 2,
      _chapterHandleWidth,
      _idleChapterHandleHeight,
    );

    if (_expandedHitRect(chapterRect, 8).contains(localPosition)) {
      return SliderLayer.chapter;
    }
    if (_expandedHitRect(bookRect, 10).contains(localPosition)) {
      return SliderLayer.book;
    }
    return null;
  }

  Rect _expandedHitRect(Rect rect, double padding) {
    return Rect.fromLTRB(
      rect.left - padding,
      rect.top - padding,
      rect.right + padding,
      rect.bottom + padding,
    );
  }

  _AnchorPair _resolveIdleAnchors(
    _TrackBounds track, {
    required bool avoidOverlap,
  }) {
    final bookY = _focusToTrackY(_bookFocus, track, widget.books.length);
    var chapterY = _focusToTrackY(
      _chapterFocus,
      track,
      widget.books[_selectedBookIndex].chapterCount,
    );

    if (avoidOverlap) {
      chapterY = _avoidOverlap(track, bookY, chapterY);
    }

    return _AnchorPair(bookY: bookY, chapterY: chapterY);
  }

  _TrackBounds _trackBounds(double height) {
    final min = math.min(_safeTop, math.max(30.0, height * 0.18));
    final max = math.max(min + 1, height - math.min(_safeBottom, height * 0.18));
    return _TrackBounds(min: min, max: max.toDouble());
  }

  _TrackBounds _chapterSelectionTrack(
    _TrackBounds fullTrack,
    int chapterCount,
    double anchorY,
    int anchorChapter,
  ) {
    if (chapterCount <= 1) {
      final clamped = anchorY.clamp(fullTrack.min, fullTrack.max).toDouble();
      return _TrackBounds(min: clamped, max: clamped + 1);
    }

    final spanFactor = ((chapterCount - 1) / 42).clamp(0.0, 1.0);
    final desiredHeight =
        lerpDouble(150, fullTrack.max - fullTrack.min, spanFactor) ??
            (fullTrack.max - fullTrack.min);
    final step = desiredHeight / math.max(1, chapterCount - 1);
    final normalizedAnchor = anchorChapter.clamp(1, chapterCount) - 1;

    var min = anchorY - normalizedAnchor * step;
    var max = min + step * (chapterCount - 1);

    if (min < fullTrack.min) {
      max += fullTrack.min - min;
      min = fullTrack.min;
    }
    if (max > fullTrack.max) {
      min -= max - fullTrack.max;
      max = fullTrack.max;
    }

    min = min.clamp(fullTrack.min, fullTrack.max).toDouble();
    max = max.clamp(fullTrack.min, fullTrack.max).toDouble();
    if (max - min < 1) {
      max = min + 1;
    }
    return _TrackBounds(min: min, max: max);
  }

  double _softClampY(double rawY, _TrackBounds track) {
    if (rawY < track.min) {
      final overshoot = track.min - rawY;
      return track.min - math.sqrt(overshoot) * 4.4;
    }
    if (rawY > track.max) {
      final overshoot = rawY - track.max;
      return track.max + math.sqrt(overshoot) * 4.4;
    }
    return rawY;
  }

  double _applyBookSelection(double y, _TrackBounds track) {
    final progress = _magneticFocus(
      _mapTrackToFocus(y, track, widget.books.length),
      _selectedBookIndex.toDouble(),
      intensity: 1.14,
    );
    final nextIndex =
        progress.round().clamp(0, widget.books.length - 1).toInt();
    if (nextIndex != _selectedBookIndex) {
      HapticFeedback.selectionClick();
    }
    _bookFocus = progress;
    _selectedBookIndex = nextIndex;
    final chapterCount = widget.books[_selectedBookIndex].chapterCount;
    _selectedChapter = _selectedChapter.clamp(1, chapterCount).toInt();
    _chapterFocus = (_selectedChapter - 1).toDouble();
    _notifyPreview();
    return _focusToTrackY(progress, track, widget.books.length);
  }

  double _applyChapterSelection(double y, _TrackBounds track) {
    final chapterCount = widget.books[_selectedBookIndex].chapterCount;
    final progress = _magneticFocus(
      _mapTrackToFocus(y, track, chapterCount),
      (_selectedChapter - 1).toDouble(),
    );
    final nextChapter =
        progress.round().clamp(0, chapterCount - 1).toInt() + 1;
    if (nextChapter != _selectedChapter) {
      HapticFeedback.selectionClick();
    }
    _chapterFocus = progress;
    _selectedChapter = nextChapter;
    _notifyPreview();
    return _focusToTrackY(progress, track, chapterCount);
  }

  double _mapTrackToFocus(double y, _TrackBounds track, int itemCount) {
    if (itemCount <= 1) {
      return 0;
    }
    final normalized = ((y - track.min) / (track.max - track.min))
        .clamp(0.0, 1.0)
        .toDouble();
    return normalized * (itemCount - 1);
  }

  double _focusToTrackY(double focus, _TrackBounds track, int itemCount) {
    if (itemCount <= 1) {
      return (track.min + track.max) / 2;
    }
    final normalized = (focus / (itemCount - 1)).clamp(0.0, 1.0).toDouble();
    return lerpDouble(track.min, track.max, normalized) ?? track.min;
  }

  double _magneticFocus(
    double focus,
    double currentDiscrete, {
    double intensity = 1,
  }) {
    final currentDelta = (focus - currentDiscrete).abs();
    if (currentDelta < 0.08) {
      return lerpDouble(focus, currentDiscrete, 0.52 * intensity) ?? focus;
    }
    if (currentDelta < 0.18) {
      return lerpDouble(focus, currentDiscrete, 0.24 * intensity) ?? focus;
    }

    final nearest = focus.roundToDouble();
    final delta = focus - nearest;
    final distance = delta.abs();

    if (distance < 0.09) {
      return lerpDouble(focus, nearest, (0.6 * intensity).clamp(0.0, 0.82)) ??
          focus;
    }

    final attraction = Curves.easeOutQuad.transform(
      (1 - (distance / 0.5).clamp(0.0, 1.0)).toDouble(),
    );
    final factor =
        (0.12 + 0.22 * attraction) * intensity.clamp(0.8, 1.3).toDouble();
    return lerpDouble(focus, nearest, factor.clamp(0.0, 0.42)) ?? focus;
  }

  Rect _selectedBookLabelRect(Size size, double centerY) {
    return Rect.fromCenter(
      center: Offset(size.width - 88, centerY),
      width: 94,
      height: 64,
    );
  }

  void _handleChapterHandleAnimationEnd() {
    if (!_isActive || _layer != SliderLayer.chapter || !_chapterEngaging) {
      return;
    }

    final track = _latestTrackBounds;
    if (track == null) {
      return;
    }

    setState(() {
      _syncChapterSelectionToHandle(track);
      _chapterEngaging = false;
    });
    _notifyPreview();

    if (_commitAfterChapterEngage) {
      _finalizeCommit();
    }
  }

  void _syncChapterSelectionToHandle(_TrackBounds track) {
    final anchorY = _chapterRangeAnchorY ?? _chapterHandleY;
    final anchorChapter = _chapterRangeAnchorChapter ?? _selectedChapter;
    final chapterCount = widget.books[_selectedBookIndex].chapterCount;
    final chapterTrack = _chapterSelectionTrack(
      track,
      chapterCount,
      anchorY,
      anchorChapter,
    );
    final snappedChapterY = _softClampY(_chapterHandleY, chapterTrack);
    final progress = _magneticFocus(
      _mapTrackToFocus(snappedChapterY, chapterTrack, chapterCount),
      (_selectedChapter - 1).toDouble(),
    );
    _chapterFocus = progress;
    _selectedChapter =
        progress.round().clamp(0, chapterCount - 1).toInt() + 1;
    _chapterHandleY = _focusToTrackY(progress, chapterTrack, chapterCount);
  }

  void _notifyPreview() {
    final callback = widget.onPreviewLocation;
    if (callback == null || !_isActive) {
      return;
    }

    final book = widget.books[_selectedBookIndex];
    final location = BibleLocation(
      translationId: widget.currentLocation.translationId,
      bookId: book.id,
      chapter: _selectedChapter.clamp(1, book.chapterCount).toInt(),
    );
    final signature =
        '${location.translationId}-${location.bookId}-${location.chapter}';
    if (_lastPreviewSignature == signature) {
      return;
    }
    _lastPreviewSignature = signature;
    callback(location);
  }

  Iterable<int> _visibleIndexes(int itemCount, double focus) sync* {
    final center = focus.round();
    for (var index = center - _visibleRange;
        index <= center + _visibleRange;
        index++) {
      if (index >= 0 && index < itemCount) {
        yield index;
      }
    }
  }

  void _syncWithLocation() {
    _syncWithLocationOverride(widget.currentLocation);
  }

  void _syncWithLocationOverride(BibleLocation location) {
    final bookIndex = widget.books.indexWhere((book) => book.id == location.bookId);
    _selectedBookIndex = bookIndex < 0 ? 0 : bookIndex;
    final chapterCount = widget.books[_selectedBookIndex].chapterCount;
    _selectedChapter = location.chapter.clamp(1, chapterCount).toInt();
    _bookFocus = _selectedBookIndex.toDouble();
    _chapterFocus = (_selectedChapter - 1).toDouble();
  }

  double _avoidOverlap(_TrackBounds track, double bookY, double chapterY) {
    if ((chapterY - bookY).abs() >= _minimumIdleGap) {
      return chapterY.clamp(track.min, track.max).toDouble();
    }
    final direction = chapterY >= bookY ? 1.0 : -1.0;
    return (bookY + direction * _minimumIdleGap)
        .clamp(track.min, track.max)
        .toDouble();
  }

  Duration get _bookHandleDuration {
    if (!_isActive) {
      return const Duration(milliseconds: 780);
    }
    if (_bookSelectionFrozen) {
      return const Duration(milliseconds: 180);
    }
    return const Duration(milliseconds: 88);
  }

  Curve get _bookHandleCurve {
    if (!_isActive) {
      return Curves.easeOutExpo;
    }
    return _bookSelectionFrozen ? Curves.easeOutQuart : Curves.easeOutCubic;
  }

  Duration get _chapterHandleDuration {
    if (!_isActive) {
      return const Duration(milliseconds: 860);
    }
    if (_layer == SliderLayer.book) {
      return const Duration(milliseconds: 180);
    }
    return _chapterEngaging
        ? const Duration(milliseconds: 340)
        : const Duration(milliseconds: 140);
  }

  Curve get _chapterHandleCurve {
    if (!_isActive) {
      return Curves.easeOutExpo;
    }
    if (_layer == SliderLayer.book) {
      return Curves.easeOutCubic;
    }
    return _chapterEngaging ? Curves.easeOutQuint : Curves.easeOutQuart;
  }

  static double bell(double distance, double sigma) {
    final normalized = distance / sigma;
    return math.exp(-0.5 * normalized * normalized);
  }
}

class _HandleShell extends StatelessWidget {
  const _HandleShell({
    super.key,
    required this.width,
    required this.height,
    required this.active,
    required this.label,
    required this.value,
    required this.holdProgress,
  });

  final double width;
  final double height;
  final bool active;
  final String label;
  final String value;
  final double holdProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.surface.withValues(alpha: active ? 0.97 : 0.78);

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: active ? 0.08 : 0.04),
              blurRadius: active ? 20 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipPath(
          clipper: _EdgeWaterDropClipper(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
              gradient: LinearGradient(
                begin: const Alignment(-1, -0.1),
                end: const Alignment(1, 0.14),
                colors: [
                  Colors.white.withValues(alpha: active ? 0.98 : 0.9),
                  base,
                  Color.lerp(base, Colors.black, 0.05)!,
                ],
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (holdProgress > 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: FractionallySizedBox(
                      widthFactor: holdProgress.clamp(0.0, 1.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0),
                              theme.colorScheme.primary.withValues(alpha: 0.12),
                              theme.colorScheme.primary.withValues(alpha: 0.22),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
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
      ),
    );
  }
}

class _BookWheelItem extends StatelessWidget {
  const _BookWheelItem({
    super.key,
    required this.book,
    required this.isSelected,
    required this.locked,
    required this.distance,
    required this.centerY,
  });

  final BookSummary book;
  final bool isSelected;
  final bool locked;
  final double distance;
  final double centerY;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bell = _WaterDropSliderState.bell(distance, 1.9);
    final scale = lerpDouble(0.7, 1.0, bell)!;
    final opacity = lerpDouble(0.12, 1.0, bell)!;
    final x = -(26 + 78 * bell);
    final y = centerY + distance * _WaterDropSliderState._wheelGap - 24;

    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          book.abbreviation,
          textAlign: TextAlign.right,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            fontSize: lerpDouble(16, 24, bell),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 140),
          opacity: isSelected ? 1 : 0,
          child: Text(
            book.name,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
        ),
      ],
    );

    return Positioned(
      top: y,
      right: 4,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: Offset(x, 0),
              child: SizedBox(
                width: 122,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutQuart,
                    scale: locked ? 1 : 0.985,
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutQuart,
                      padding: EdgeInsets.symmetric(
                        horizontal: locked ? 12 : 10,
                        vertical: locked ? 5 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: locked
                            ? theme.colorScheme.surface.withValues(alpha: 0.52)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: locked
                              ? theme.colorScheme.primary.withValues(alpha: 0.24)
                              : Colors.transparent,
                        ),
                        boxShadow: locked
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.06,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: label,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChapterWheelItem extends StatelessWidget {
  const _ChapterWheelItem({
    super.key,
    required this.chapter,
    required this.isSelected,
    required this.distance,
    required this.centerY,
  });

  final int chapter;
  final bool isSelected;
  final double distance;
  final double centerY;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bell = _WaterDropSliderState.bell(distance, 1.7);
    final scale = lerpDouble(0.72, 1.0, bell)!;
    final opacity = lerpDouble(0.14, 1.0, bell)!;
    final x = -(18 + 56 * bell);
    final y = centerY + distance * _WaterDropSliderState._wheelGap - 18;
    final fontSize =
        chapter >= 100 ? lerpDouble(16, 24, bell) : lerpDouble(19, 30, bell);

    return Positioned(
      top: y,
      right: 8,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.centerRight,
            child: Transform.translate(
              offset: Offset(x, 0),
              child: SizedBox(
                width: 72,
                child: Text(
                  '$chapter',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: fontSize,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EdgeWaterDropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(size.width, 0);
    path.lineTo(size.width, size.height);

    const steps = 52;
    for (var index = steps; index >= 0; index--) {
      final t = index / steps;
      final bell = math.pow(math.sin(math.pi * t), 1.34).toDouble();
      final inset = size.width * 0.9 * bell;
      path.lineTo(size.width - inset, size.height * t);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _TrackBounds {
  const _TrackBounds({
    required this.min,
    required this.max,
  });

  final double min;
  final double max;
}

class _AnchorPair {
  const _AnchorPair({
    required this.bookY,
    required this.chapterY,
  });

  final double bookY;
  final double chapterY;
}
