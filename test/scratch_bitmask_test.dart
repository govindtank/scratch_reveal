import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scratch_reveal/scratch_reveal.dart';

void main() {
  group('ScratchBitmaskGrid Unit Tests', () {
    test('Initial progress is 0.0', () {
      final grid = ScratchBitmaskGrid(cols: 10, rows: 10);
      expect(grid.progress, 0.0);
      expect(grid.scratchedCount, 0);
      expect(grid.totalCells, 100);
    });

    test('scratchLine updates intersected cells and increases progress', () {
      final grid = ScratchBitmaskGrid(cols: 10, rows: 10);
      const canvasSize = Size(100, 100);

      // Scratch a horizontal stroke across the middle
      grid.scratchLine(
        const Offset(10, 50),
        const Offset(90, 50),
        15.0,
        canvasSize,
      );

      expect(grid.scratchedCount, greaterThan(15));
      expect(grid.progress, greaterThan(0.15));
      expect(grid.progress, lessThanOrEqualTo(1.0));
    });

    test('reset clears scratched state back to 0.0', () {
      final grid = ScratchBitmaskGrid(cols: 10, rows: 10);
      const canvasSize = Size(100, 100);

      grid.scratchLine(
          const Offset(50, 50), const Offset(50, 50), 20.0, canvasSize);
      expect(grid.progress, greaterThan(0.0));

      grid.reset();
      expect(grid.progress, 0.0);
      expect(grid.scratchedCount, 0);
    });
  });
}
