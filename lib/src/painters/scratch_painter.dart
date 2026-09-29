import 'package:flutter/material.dart';
import '../scratch_config.dart';

/// High-performance [CustomPainter] that cuts transparent eraser paths out of a cover foil layer using GPU `BlendMode.clear`.
class ScratchPainter extends CustomPainter {
  /// The collection of drawn scratch line segments.
  final List<ScratchStroke> strokes;

  /// The solid background color of the scratch cover foil.
  final Color coverColor;

  /// Optional gradient for the scratch cover foil.
  final Gradient? coverGradient;

  /// Current opacity of the foil layer during reveal transitions.
  final double opacity;

  /// Creates a [ScratchPainter].
  const ScratchPainter({
    required this.strokes,
    this.coverColor = const Color(0xFF94A3B8),
    this.coverGradient,
    this.opacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || opacity <= 0.0) {
      return;
    }

    final Rect bounds = Offset.zero & size;

    // 1. Offscreen layer for BlendMode.clear masking
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

    // 3. Clear scratched paths using GPU BlendMode.clear with configured shape
    final Paint clearPaint = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;

    for (final stroke in strokes) {
      switch (stroke.shape) {
        case ScratchBrushShape.circle:
        case ScratchBrushShape.coin:
          clearPaint.style = PaintingStyle.stroke;
          clearPaint.strokeCap = stroke.shape == ScratchBrushShape.coin
              ? StrokeCap.square
              : StrokeCap.round;
          clearPaint.strokeWidth = stroke.size;
          canvas.drawLine(stroke.start, stroke.end, clearPaint);
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

    canvas.restore();
  }

  @override
  bool shouldRepaint(ScratchPainter oldDelegate) {
    return oldDelegate.strokes.length != strokes.length ||
        oldDelegate.opacity != opacity ||
        oldDelegate.coverColor != coverColor ||
        oldDelegate.coverGradient != coverGradient;
  }
}
