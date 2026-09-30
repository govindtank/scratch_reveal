import 'package:flutter/material.dart';

/// Brush tip shapes for scratching.
enum ScratchBrushShape {
  /// Circular soft-edge brush.
  circle,

  /// Flat coin edge simulator.
  coin,

  /// Rectangular eraser chisel.
  square,
}

/// Transition animations when the scratch threshold is achieved.
enum ScratchRevealAnimation {
  /// Simple opacity fade-out of remaining foil.
  fade,

  /// Smooth fade and scale expansion.
  fadeAndScale,

  /// Slide-away foil transition.
  slideUp,
}

/// Represents a single scratch point or stroke line segment.
class ScratchStroke {
  /// Starting coordinate.
  final Offset start;

  /// Ending coordinate.
  final Offset end;

  /// Brush size thickness.
  final double size;

  /// Brush tip shape.
  final ScratchBrushShape shape;

  /// Creates a [ScratchStroke].
  const ScratchStroke({
    required this.start,
    required this.end,
    required this.size,
    this.shape = ScratchBrushShape.circle,
  });
}

/// Preset foil patterns and textures for scratch cards.
class ScratchFoilPreset {
  /// Silver foil with metallic linear gradient.
  static BoxDecoration silver({BorderRadius? borderRadius}) {
    return BoxDecoration(
      borderRadius: borderRadius,
      gradient: const LinearGradient(
        colors: [
          Color(0xFFE0E0E0),
          Color(0xFFBDBDBD),
          Color(0xFFEEEEEE),
          Color(0xFF9E9E9E)
        ],
        stops: [0.0, 0.35, 0.7, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Gold foil with metallic linear gradient.
  static BoxDecoration gold({BorderRadius? borderRadius}) {
    return BoxDecoration(
      borderRadius: borderRadius,
      gradient: const LinearGradient(
        colors: [
          Color(0xFFFFDF00),
          Color(0xFFD4AF37),
          Color(0xFFFFE57F),
          Color(0xFFAA771C)
        ],
        stops: [0.0, 0.35, 0.7, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
