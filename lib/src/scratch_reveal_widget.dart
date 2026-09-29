import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'painters/scratch_painter.dart';
import 'scratch_bitmask_grid.dart';
import 'scratch_config.dart';

/// An interactive scratch-to-reveal card widget for Flutter with sub-millisecond bitmask progress tracking.
class ScratchReveal extends StatefulWidget {
  /// The underlying prize or content to be revealed.
  final Widget revealedChild;

  /// Optional widget displayed on top as the scratch foil (if null, uses [coverColor] or [coverGradient]).
  final Widget? cover;

  /// Solid color for the scratch cover foil.
  final Color coverColor;

  /// Optional gradient for the scratch cover foil (e.g. silver/gold foil look).
  final Gradient? coverGradient;

  /// Thickness of the scratch brush stroke in logical pixels.
  final double brushSize;

  /// Shape of the brush tip (circle, coin, square).
  final ScratchBrushShape brushShape;

  /// Threshold fraction in `[0.0, 1.0]` required to trigger auto-reveal.
  final double threshold;

  /// Whether to automatically fade out the remaining foil when the threshold is reached.
  final bool autoReveal;

  /// Animation duration for the auto-reveal transition.
  final Duration revealDuration;

  /// Callback triggered when the scratch percentage crosses the [threshold].
  final VoidCallback? onThresholdReached;

  /// Callback triggered when the reveal animation completes.
  final VoidCallback? onRevealComplete;

  /// Callback emitting continuous scratch progress in `[0.0, 1.0]`.
  final ValueChanged<double>? onProgressUpdate;

  /// Whether to trigger a light haptic tap on scratch strokes.
  final bool enableHaptics;

  /// Whether scratching interaction is enabled.
  final bool enabled;

  /// Creates a [ScratchReveal] widget.
  const ScratchReveal({
    super.key,
    required this.revealedChild,
    this.cover,
    this.coverColor = const Color(0xFF64748B),
    this.coverGradient,
    this.brushSize = 36.0,
    this.brushShape = ScratchBrushShape.circle,
    this.threshold = 0.60,
    this.autoReveal = true,
    this.revealDuration = const Duration(milliseconds: 600),
    this.onThresholdReached,
    this.onRevealComplete,
    this.onProgressUpdate,
    this.enableHaptics = false,
    this.enabled = true,
  });

  @override
  State<ScratchReveal> createState() => ScratchRevealState();
}

/// State controller for [ScratchReveal] exposing reset and programmatic reveal methods.
class ScratchRevealState extends State<ScratchReveal>
    with SingleTickerProviderStateMixin {
  final List<ScratchStroke> _strokes = [];
  late final ScratchBitmaskGrid _bitmask;
  late final AnimationController _revealController;
  late final Animation<double> _opacityAnimation;

  Offset? _lastPoint;
  bool _isThresholdReached = false;

  @override
  void initState() {
    super.initState();
    _bitmask = ScratchBitmaskGrid(cols: 24, rows: 24);
    _revealController = AnimationController(
      vsync: this,
      duration: widget.revealDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onRevealComplete?.call();
        }
      });
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  /// Current scratch progress in `[0.0, 1.0]`.
  double get progress => _bitmask.progress;

  /// Whether the scratch threshold has been reached.
  bool get isRevealed => _isThresholdReached;

  /// Resets the scratch foil and bitmask grid back to pristine state.
  void reset() {
    setState(() {
      _strokes.clear();
      _bitmask.reset();
      _isThresholdReached = false;
      _lastPoint = null;
      _revealController.reset();
    });
    widget.onProgressUpdate?.call(0.0);
  }

  /// Programmatically reveals the underlying card.
  void reveal() {
    if (!_isThresholdReached) {
      _isThresholdReached = true;
      _revealController.forward();
      widget.onThresholdReached?.call();
      widget.onProgressUpdate?.call(1.0);
    }
  }

  void _onPanStart(DragStartDetails details, Size size) {
    if (_isThresholdReached || !widget.enabled) {
      return;
    }
    _lastPoint = details.localPosition;
    _addStroke(_lastPoint!, _lastPoint!, size);
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (_isThresholdReached || !widget.enabled) {
      return;
    }
    final Offset currentPoint = details.localPosition;
    if (_lastPoint != null) {
      _addStroke(_lastPoint!, currentPoint, size);
    }
    _lastPoint = currentPoint;
  }

  void _onPanEnd(DragEndDetails details) {
    _lastPoint = null;
  }

  void _addStroke(Offset start, Offset end, Size size) {
    setState(() {
      _strokes.add(ScratchStroke(
        start: start,
        end: end,
        size: widget.brushSize,
        shape: widget.brushShape,
      ));
    });

    _bitmask.scratchLine(start, end, widget.brushSize / 2, size);
    final double currentProgress = _bitmask.progress;
    widget.onProgressUpdate?.call(currentProgress);

    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }

    if (!_isThresholdReached && currentProgress >= widget.threshold) {
      _isThresholdReached = true;
      if (widget.autoReveal) {
        _revealController.forward();
      }
      widget.onThresholdReached?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          fit: StackFit.passthrough,
          children: [
            // 1. Revealed Prize Widget (Bottom Layer)
            widget.revealedChild,

            // 2. Scratch Foil Mask Layer (Top Layer)
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                if (_opacityAnimation.value <= 0.0) {
                  return const SizedBox.shrink();
                }

                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (d) => _onPanStart(d, size),
                    onPanUpdate: (d) => _onPanUpdate(d, size),
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      size: size,
                      painter: ScratchPainter(
                        strokes: _strokes,
                        coverColor: widget.coverColor,
                        coverGradient: widget.coverGradient,
                        opacity: 1.0,
                      ),
                      child: widget.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
