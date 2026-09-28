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
