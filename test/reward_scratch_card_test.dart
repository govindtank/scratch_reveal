import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scratch_reveal/scratch_reveal.dart';

void main() {
  group('RewardScratchCard Widget Tests', () {
    testWidgets('renders un-scratched cover foil with title and icon',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RewardScratchCard(
              rewardTitle: '₹ 250 Cashback',
              rewardSubtitle: 'Credited to your linked bank account',
              couponCode: 'CASH250',
            ),
          ),
        ),
      );

      expect(find.text('Scratch & Win'), findsOneWidget);
      expect(find.text('SCRATCH TO REVEAL'), findsOneWidget);
      expect(find.byIcon(Icons.monetization_on_rounded), findsOneWidget);
    });

    testWidgets('scratching gesture reveals reward and unlocks claim action',
        (tester) async {
      bool claimClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RewardScratchCard(
                threshold: 0.05, // 5% threshold
                rewardTitle: 'Flat 50% OFF',
                rewardSubtitle: 'On all electronics',
                couponCode: 'TECH50',
                onClaimPressed: () => claimClicked = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Flat 50% OFF'), findsOneWidget);
      expect(find.text('TECH50'), findsOneWidget);

      final center = tester.getCenter(find.byType(ScratchReveal));
      final gesture = await tester.startGesture(center - const Offset(90, 0));
      await gesture.moveTo(center + const Offset(90, 0));
      await gesture.moveTo(center - const Offset(90, 50));
      await gesture.moveTo(center + const Offset(90, 50));
      await gesture.up();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Claim Reward'));
      await tester.pump();

      expect(claimClicked, isTrue);
    });
  });
}
