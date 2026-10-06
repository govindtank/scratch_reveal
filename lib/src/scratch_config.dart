import 'package:flutter/material.dart';

/// Brush tip shapes and textures for scratching.
enum ScratchBrushShape {
  /// Circular soft-edge brush.
  circle,

  /// Flat angled coin scraper with parallel micro-grooves.
  coin,

  /// Textured organic scratch with rough, jagged edges.
  rough,

  /// Multi-bristle scratch brush.
  textured,

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

  /// Random seed offset for rough jagged variations.
  final double jitter;

  /// Creates a [ScratchStroke].
  const ScratchStroke({
    required this.start,
    required this.end,
    required this.size,
    this.shape = ScratchBrushShape.coin,
    this.jitter = 0.0,
  });
}

/// Represents an airborne foil shaving or sparkle dust particle emitted while scratching.
class ScratchParticle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double opacity;
  double rotation;
  double rotationSpeed;
  double life;

  ScratchParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
    this.life = 1.0,
  });

  /// Updates physics and returns true if particle is still alive.
  bool update(double dt) {
    position += velocity * dt;
    velocity = Offset(velocity.dx * 0.92, velocity.dy * 0.92 + 160 * dt);
    rotation += rotationSpeed * dt;
    life -= dt * 2.0;
    opacity = (life).clamp(0.0, 1.0);
    return life > 0;
  }
}

/// Preset foil patterns and textures for scratch cards.
class ScratchFoilPreset {
  /// Silver foil with metallic linear gradient.
  static BoxDecoration silver({BorderRadius? borderRadius}) {
    return BoxDecoration(
      borderRadius: borderRadius,
      gradient: const LinearGradient(
        colors: [
          Color(0xFFE2E8F0),
          Color(0xFF94A3B8),
          Color(0xFFCBD5E1),
          Color(0xFF64748B),
          Color(0xFFF1F5F9),
        ],
        stops: [0.0, 0.25, 0.55, 0.85, 1.0],
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
          Color(0xFFFFE57F),
          Color(0xFFD4AF37),
          Color(0xFFFFF9C4),
          Color(0xFFAA771C),
          Color(0xFFFFD700),
        ],
        stops: [0.0, 0.25, 0.55, 0.85, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Holographic iridescent metallic foil.
  static BoxDecoration holographic({BorderRadius? borderRadius}) {
    return BoxDecoration(
      borderRadius: borderRadius,
      gradient: const LinearGradient(
        colors: [
          Color(0xFF80D0C7),
          Color(0xFF13547A),
          Color(0xFF80D0C7),
          Color(0xFF808080),
        ],
        stops: [0.0, 0.35, 0.7, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
