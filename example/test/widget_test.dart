import 'package:flutter_test/flutter_test.dart';
import 'package:scratch_reveal_example/main.dart';

void main() {
  testWidgets('Scratch reveal example smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ScratchDemoApp());
    await tester.pumpAndSettle();

    expect(find.text('Scratch Reveal Demo'), findsOneWidget);
    expect(find.text('SCRATCH HERE TO REVEAL'), findsOneWidget);
    expect(find.text('Scratch Progress'), findsOneWidget);
  });
}
