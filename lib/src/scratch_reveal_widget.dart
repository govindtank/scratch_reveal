import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'painters/scratch_painter.dart';
import 'scratch_bitmask_grid.dart';
import 'scratch_config.dart';

/// An interactive scratch-to-reveal card widget for Flutter with realistic coin/brush physical texture, flying metallic foil dust particles, and sub-millisecond bitmask progress tracking.
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

  /// Shape and texture of the brush tip ([ScratchBrushShape.coin], [ScratchBrushShape.rough], [ScratchBrushShape.circle], [ScratchBrushShape.textured]).
  final ScratchBrushShape brushShape;

  /// Whether to emit flying metallic foil dust and shaving particles while scratching.
  final bool showFoilParticles;

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

  /// Whether to trigger tactile haptic pulses on scratch strokes.
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
    this.brushSize = 40.0,
    this.brushShape = ScratchBrushShape.coin,
    this.showFoilParticles = true,
    this.threshold = 0.60,
    this.autoReveal = true,
    this.revealDuration = const Duration(milliseconds: 600),
    this.onThresholdReached,
    this.onRevealComplete,
    this.onProgressUpdate,
    this.enableHaptics = true,
    this.enabled = true,
  });

  /// Factory constructor for a realistic silver scratch-off lottery card.
  factory ScratchReveal.silverLottery({
    Key? key,
    required Widget revealedChild,
    Widget? cover,
    double brushSize = 42.0,
    double threshold = 0.60,
    VoidCallback? onThresholdReached,
    VoidCallback? onRevealComplete,
    ValueChanged<double>? onProgressUpdate,
    bool enableHaptics = true,
  }) {
    return ScratchReveal(
      key: key,
      revealedChild: revealedChild,
      cover: cover,
      brushSize: brushSize,
      brushShape: ScratchBrushShape.coin,
      showFoilParticles: true,
      threshold: threshold,
      coverGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE2E8F0),
          Color(0xFF94A3B8),
          Color(0xFFCBD5E1),
          Color(0xFF64748B),
          Color(0xFFF1F5F9),
        ],
        stops: [0.0, 0.25, 0.55, 0.85, 1.0],
      ),
      onThresholdReached: onThresholdReached,
      onRevealComplete: onRevealComplete,
      onProgressUpdate: onProgressUpdate,
      enableHaptics: enableHaptics,
    );
  }

  /// Factory constructor for a luxury gold scratch-off lottery card.
  factory ScratchReveal.goldLottery({
    Key? key,
    required Widget revealedChild,
    Widget? cover,
    double brushSize = 42.0,
    double threshold = 0.60,
    VoidCallback? onThresholdReached,
    VoidCallback? onRevealComplete,
    ValueChanged<double>? onProgressUpdate,
    bool enableHaptics = true,
  }) {
    return ScratchReveal(
      key: key,
      revealedChild: revealedChild,
      cover: cover,
      brushSize: brushSize,
      brushShape: ScratchBrushShape.coin,
      showFoilParticles: true,
      threshold: threshold,
      coverGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFE57F),
          Color(0xFFD4AF37),
          Color(0xFFFFF9C4),
          Color(0xFFAA771C),
          Color(0xFFFFD700),
        ],
        stops: [0.0, 0.25, 0.55, 0.85, 1.0],
      ),
      onThresholdReached: onThresholdReached,
      onRevealComplete: onRevealComplete,
      onProgressUpdate: onProgressUpdate,
      enableHaptics: enableHaptics,
    );
  }

  @override
  State<ScratchReveal> createState() => ScratchRevealState();
}

/// State controller for [ScratchReveal] exposing reset and programmatic reveal methods.
class ScratchRevealState extends State<ScratchReveal>
    with TickerProviderStateMixin {
  final List<ScratchStroke> _strokes = [];
  final List<ScratchParticle> _particles = [];
  final math.Random _rng = math.Random();

  late final ScratchBitmaskGrid _bitmask;
  late final AnimationController _revealController;
  late final Animation<double> _opacityAnimation;
  Ticker? _particleTicker;
  Duration _lastElapsed = Duration.zero;

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

    _particleTicker = createTicker(_onParticleTick);
  }

  void _onParticleTick(Duration elapsed) {
    if (_particles.isEmpty) {
      _particleTicker?.stop();
      _lastElapsed = Duration.zero;
      return;
    }

    final double dt = _lastElapsed == Duration.zero
        ? 0.016
        : ((elapsed - _lastElapsed).inMicroseconds / 1000000.0).clamp(0.001, 0.05);
    _lastElapsed = elapsed;

    setState(() {
      _particles.removeWhere((p) => !p.update(dt));
    });
  }

  void _spawnParticles(Offset pos, Offset delta) {
    if (!widget.showFoilParticles || _isThresholdReached) return;

    final baseColor = widget.coverColor;
    final count = 3 + _rng.nextInt(3);

    for (int i = 0; i < count; i++) {
      final angle = _rng.nextDouble() * 2 * math.pi;
      final speed = 40.0 + _rng.nextDouble() * 120.0;
      final pDelta = delta.distance > 1.0 ? delta / delta.distance : Offset.zero;

      final velocity = Offset(
        math.cos(angle) * speed + pDelta.dx * 60.0,
        math.sin(angle) * speed + pDelta.dy * 60.0 - 30.0,
      );

      _particles.add(ScratchParticle(
        position: pos + Offset(_rng.nextDouble() * 8 - 4, _rng.nextDouble() * 8 - 4),
        velocity: velocity,
        size: 2.5 + _rng.nextDouble() * 3.5,
        color: _rng.nextBool()
            ? Colors.white
            : Color.lerp(baseColor, Colors.white, _rng.nextDouble() * 0.8)!,
        rotation: _rng.nextDouble() * 2 * math.pi,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 12.0,
        life: 0.7 + _rng.nextDouble() * 0.5,
      ));
    }

    if (_particleTicker != null && !_particleTicker!.isActive) {
      _lastElapsed = Duration.zero;
      _particleTicker!.start();
    }
  }

  @override
  void dispose() {
    _particleTicker?.dispose();
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
      _particles.clear();
      _bitmask.reset();
      _isThresholdReached = false;
      _lastPoint = null;
    });
    _revealController.reset();
    widget.onProgressUpdate?.call(0.0);
  }

  /// Programmatically reveals the underlying card content with the configured animation.
  void reveal() {
    if (_isThresholdReached) return;
    _isThresholdReached = true;
    widget.onThresholdReached?.call();
    widget.onProgressUpdate?.call(1.0);
    if (widget.autoReveal) {
      _revealController.forward();
    }
  }

  void _onPanStart(DragStartDetails details, BoxConstraints constraints) {
    if (!widget.enabled || _isThresholdReached) return;
    final pos = details.localPosition;
    _lastPoint = pos;
    _addStroke(pos, pos, constraints);
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (!widget.enabled || _isThresholdReached) return;
    final currentPoint = details.localPosition;
    if (_lastPoint != null) {
      final delta = currentPoint - _lastPoint!;
      _addStroke(_lastPoint!, currentPoint, constraints);
      _spawnParticles(currentPoint, delta);
    }
    _lastPoint = currentPoint;
  }

  void _onPanEnd(DragEndDetails details) {
    _lastPoint = null;
  }

  void _addStroke(Offset start, Offset end, BoxConstraints constraints) {
    setState(() {
      _strokes.add(ScratchStroke(
        start: start,
        end: end,
        size: widget.brushSize,
        shape: widget.brushShape,
        jitter: _rng.nextDouble(),
      ));
    });

    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final countBefore = _bitmask.scratchedCount;
    _bitmask.scratchLine(start, end, widget.brushSize / 2, size);

    if (_bitmask.scratchedCount != countBefore) {
      final currentProgress = _bitmask.progress;
      widget.onProgressUpdate?.call(currentProgress);

      if (currentProgress >= widget.threshold && !_isThresholdReached) {
        _isThresholdReached = true;
        widget.onThresholdReached?.call();
        if (widget.enableHaptics) {
          HapticFeedback.mediumImpact();
        }
        if (widget.autoReveal) {
          _revealController.forward();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: Underlying Revealed Prize/Content
            widget.revealedChild,

            // Layer 2: Scratch Foil + Particle Shavings
            if (!_revealController.isCompleted)
              AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (d) => _onPanStart(d, constraints),
                      onPanUpdate: (d) => _onPanUpdate(d, constraints),
                      onPanEnd: _onPanEnd,
                      child: CustomPaint(
                        painter: ScratchPainter(
                          strokes: _strokes,
                          particles: _particles,
                          coverColor: widget.coverColor,
                          coverGradient: widget.coverGradient,
                          opacity: _opacityAnimation.value,
                        ),
                        child: widget.cover != null
                            ? IgnorePointer(child: widget.cover)
                            : null,
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
