import 'package:flutter/material.dart';
import '../scratch_config.dart';

/// High-performance [CustomPainter] that cuts realistic textured scratch paths out of a cover foil layer using GPU `BlendMode.clear`, and renders flying foil dust particles.
class ScratchPainter extends CustomPainter {
  /// The collection of drawn scratch line segments.
  final List<ScratchStroke> strokes;

  /// Active flying foil shavings and sparkle dust particles.
  final List<ScratchParticle> particles;

  /// The solid background color of the scratch cover foil.
  final Color coverColor;

  /// Optional gradient for the scratch cover foil.
  final Gradient? coverGradient;

  /// Current opacity of the foil layer during reveal transitions.
  final double opacity;

  /// Whether to render micro-textured foil surface details.
  final bool enableFoilTexture;

  /// Creates a [ScratchPainter].
  const ScratchPainter({
    required this.strokes,
    this.particles = const [],
    this.coverColor = const Color(0xFF94A3B8),
    this.coverGradient,
    this.opacity = 1.0,
    this.enableFoilTexture = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || opacity <= 0.0) {
      return;
    }

    final Rect bounds = Offset.zero & size;

    // 1. Offscreen layer for GPU BlendMode.clear masking
    canvas.saveLayer(
      bounds,
      Paint()..color = Color.fromARGB((255 * opacity).toInt(), 255, 255, 255),
    );

    // 2. Draw Cover Foil (Color / Gradient)
    final Paint coverPaint = Paint();
    if (coverGradient != null) {
      coverPaint.shader = coverGradient!.createShader(bounds);
    } else {
      coverPaint.color = coverColor;
    }
    canvas.drawRect(bounds, coverPaint);

    // 2b. Subtle metallic micro-texture on foil
    if (enableFoilTexture && opacity > 0.1) {
      _paintFoilTexture(canvas, size);
    }

    // 3. Clear scratched paths using GPU BlendMode.clear
    final Paint clearPaint = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;

    for (final stroke in strokes) {
      _paintStroke(canvas, stroke, clearPaint);
    }

    canvas.restore();

    // 4. Draw Flying Foil Dust & Shaving Particles (on top layer)
    if (particles.isNotEmpty && opacity > 0.05) {
      _paintParticles(canvas);
    }
  }

  void _paintFoilTexture(Canvas canvas, Size size) {
    final texturePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const step = 14.0;
    for (double x = -size.height; x < size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        texturePaint,
      );
    }
  }

  void _paintStroke(Canvas canvas, ScratchStroke stroke, Paint clearPaint) {
    switch (stroke.shape) {
      case ScratchBrushShape.circle:
        clearPaint.style = PaintingStyle.stroke;
        clearPaint.strokeCap = StrokeCap.round;
        clearPaint.strokeWidth = stroke.size;
        canvas.drawLine(stroke.start, stroke.end, clearPaint);
        break;

      case ScratchBrushShape.coin:
        // Realistic coin scraper: Main stroke + parallel grooved chisel lines
        clearPaint.style = PaintingStyle.stroke;
        clearPaint.strokeCap = StrokeCap.round;
        clearPaint.strokeWidth = stroke.size;
        canvas.drawLine(stroke.start, stroke.end, clearPaint);

        // Side grooves for coin serration
        final delta = stroke.end - stroke.start;
        final len = delta.distance;
        if (len > 0.5) {
          final normal = Offset(-delta.dy / len, delta.dx / len);
          final offset1 = normal * (stroke.size * 0.28);
          final offset2 = normal * -(stroke.size * 0.28);

          clearPaint.strokeWidth = stroke.size * 0.45;
          canvas.drawLine(
              stroke.start + offset1, stroke.end + offset1, clearPaint);
          canvas.drawLine(
              stroke.start + offset2, stroke.end + offset2, clearPaint);
        }
        break;

      case ScratchBrushShape.rough:
      case ScratchBrushShape.textured:
        // Rough organic scratch with jagged jitter
        clearPaint.style = PaintingStyle.stroke;
        clearPaint.strokeCap = StrokeCap.round;
        clearPaint.strokeWidth = stroke.size;
        canvas.drawLine(stroke.start, stroke.end, clearPaint);

        // Jagged micro-fringe
        final delta = stroke.end - stroke.start;
        final len = delta.distance;
        if (len > 0.5) {
          final normal = Offset(-delta.dy / len, delta.dx / len);
          final jitterScale = (stroke.jitter != 0.0 ? stroke.jitter : 0.5);
          final offset = normal * (stroke.size * 0.35 * (jitterScale - 0.5));
          clearPaint.strokeWidth = stroke.size * 0.5;
          canvas.drawLine(
              stroke.start + offset, stroke.end + offset, clearPaint);
        }
        break;

      case ScratchBrushShape.square:
        clearPaint.style = PaintingStyle.fill;
        final Rect strokeRect = Rect.fromCenter(
          center: stroke.end,
          width: stroke.size,
          height: stroke.size,
        );
        canvas.drawRect(strokeRect, clearPaint);
        break;
    }
  }

  void _paintParticles(Canvas canvas) {
    final particlePaint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      if (p.opacity <= 0.0) continue;
      particlePaint.color = p.color.withValues(alpha: p.opacity);

      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      canvas.rotate(p.rotation);

      // Draw metallic flake polygon
      final double r = p.size;
      final path = Path()
        ..moveTo(-r, -r * 0.6)
        ..lineTo(r * 0.8, -r)
        ..lineTo(r, r * 0.7)
        ..lineTo(-r * 0.5, r)
        ..close();

      canvas.drawPath(path, particlePaint);

      // Center bright glint
      final glintPaint = Paint()
        ..color =
            Colors.white.withValues(alpha: (p.opacity * 0.8).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, (r * 0.35).clamp(0.5, 2.0), glintPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ScratchPainter oldDelegate) {
    return oldDelegate.strokes.length != strokes.length ||
        oldDelegate.particles.length != particles.length ||
        oldDelegate.opacity != opacity ||
        oldDelegate.coverColor != coverColor ||
        oldDelegate.coverGradient != coverGradient;
  }
}
