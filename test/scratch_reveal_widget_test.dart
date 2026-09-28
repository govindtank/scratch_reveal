import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scratch_reveal/scratch_reveal.dart';

void main() {
  group('ScratchReveal Widget Tests', () {
    testWidgets('ScratchReveal mounts and reveals prize on drag gesture',
        (WidgetTester tester) async {
      double latestProgress = 0.0;
      bool thresholdFired = false;
      final key = GlobalKey<ScratchRevealState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: ScratchReveal(
                  key: key,
                  brushSize: 60.0,
                  threshold: 0.15,
                  coverColor: Colors.grey,
                  revealedChild: const Text('🎉 YOU WON 100 COINS!'),
                  onProgressUpdate: (p) => latestProgress = p,
                  onThresholdReached: () => thresholdFired = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('🎉 YOU WON 100 COINS!'), findsOneWidget);

      // Perform dragging across the scratch canvas
      final center = tester.getCenter(find.byType(ScratchReveal));
      final gesture = await tester.startGesture(center - const Offset(70, 0));
      await gesture.moveTo(center + const Offset(70, 0));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(latestProgress, greaterThan(0.1));
      expect(thresholdFired, isTrue);

      // Test reset
      key.currentState?.reset();
      await tester.pumpAndSettle();
      expect(latestProgress, 0.0);
    });

    testWidgets('programmatic reveal() triggers threshold and full reveal',
        (WidgetTester tester) async {
      bool thresholdFired = false;
      final key = GlobalKey<ScratchRevealState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: ScratchReveal(
                  key: key,
                  revealedChild: const Text('PRIZE'),
                  onThresholdReached: () => thresholdFired = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      key.currentState?.reveal();
      await tester.pumpAndSettle();

      expect(thresholdFired, isTrue);
    });
  });
}
