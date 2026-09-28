import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Ultra-fast 2D spatial bitmask grid for estimating scratched area percentage in sub-millisecond time.
class ScratchBitmaskGrid {
  /// Grid column count.
  final int cols;

  /// Grid row count.
  final int rows;

  /// 1-bit per cell scratch state (true = scratched).
  late final List<bool> _cells;

  int _scratchedCount = 0;

  /// Creates a [ScratchBitmaskGrid] with given resolution (default 24x24 = 576 sample cells).
  ScratchBitmaskGrid({this.cols = 24, this.rows = 24}) {
    _cells = List<bool>.filled(cols * rows, false);
  }

  /// Total number of tracking cells.
  int get totalCells => cols * rows;

  /// Number of currently scratched cells.
  int get scratchedCount => _scratchedCount;

  /// Fraction of total canvas area scratched in `[0.0, 1.0]`.
  double get progress => totalCells > 0 ? (_scratchedCount / totalCells) : 0.0;

  /// Resets the grid back to 0% scratched.
  void reset() {
    _cells.fillRange(0, _cells.length, false);
    _scratchedCount = 0;
  }

  /// Updates grid cells intersected by a stroke from [start] to [end] with brush [radius] on a canvas of [canvasSize].
  void scratchLine(Offset start, Offset end, double radius, Size canvasSize) {
    if (canvasSize.width <= 0 || canvasSize.height <= 0) {
      return;
    }

    final double cellWidth = canvasSize.width / cols;
    final double cellHeight = canvasSize.height / rows;

    final double dx = end.dx - start.dx;
    final double dy = end.dy - start.dy;
    final double distance = math.sqrt(dx * dx + dy * dy);
    final int steps = math.max(1, (distance / (radius * 0.5)).ceil());

    for (int step = 0; step <= steps; step++) {
      final double t = steps > 0 ? (step / steps) : 0.0;
      final double px = start.dx + dx * t;
      final double py = start.dy + dy * t;

      final int minCol = math.max(0, ((px - radius) / cellWidth).floor());
      final int maxCol =
          math.min(cols - 1, ((px + radius) / cellWidth).floor());
      final int minRow = math.max(0, ((py - radius) / cellHeight).floor());
      final int maxRow =
          math.min(rows - 1, ((py + radius) / cellHeight).floor());

      final double rSquared = radius * radius;

      for (int r = minRow; r <= maxRow; r++) {
        final double cellCenterY = (r + 0.5) * cellHeight;
        final double dyCell = cellCenterY - py;

        for (int c = minCol; c <= maxCol; c++) {
          final int index = r * cols + c;
          if (_cells[index]) {
            continue; // Already scratched
          }

          final double cellCenterX = (c + 0.5) * cellWidth;
          final double dxCell = cellCenterX - px;

          if (dxCell * dxCell + dyCell * dyCell <= rSquared) {
            _cells[index] = true;
            _scratchedCount++;
          }
        }
      }
    }
  }
}
