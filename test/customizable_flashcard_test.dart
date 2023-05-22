import 'package:customizable_flashcard/flashcard_side_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:customizable_flashcard/customizable_flashcard.dart';

void main() {
  group('FlashCard:  ', () {});
  testWidgets('{ Text widgets are shown }', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FlashCard(
          ontap: () {},
          frontWidget: const Text('What is the capital of France?'),
          backWidget: const Text('Paris'),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('What is the capital of France?'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);

    // await tester.tap(find.byType(Card));
    // await tester.pump();

    // expect(find.text('What is the capital of France?'), findsOneWidget);
    // expect(find.text('Paris'), findsNothing);
  });

  testWidgets('{ onFlip callback works and returns the right side }',
      (WidgetTester tester) async {
    FlashCardSide flashCardSide = FlashCardSide.front;
    await tester.pumpWidget(
      MaterialApp(
        home: FlashCard(
          ontap: () {},
          onFlip: (side) {
            flashCardSide = side;
          },
          frontGradient:
              const LinearGradient(colors: [Colors.red, Colors.blue]),
          frontWidget: const Text('What is the capital of France?'),
          backWidget: const Text('Paris'),
        ),
      ),
    );
    // for (int i = 0; i < tester.allWidgets.length; i++) {
    //   print(tester.allWidgets.elementAt(i).toStringShort());
    // }
    await tester.tap(find.byType(AnimatedCard).first, warnIfMissed: false);
    await tester.pump();
    expect(flashCardSide == FlashCardSide.back, true);
  });

  testWidgets('{ onTap callback works }', (WidgetTester tester) async {
    bool ontapRegistered = false;
    await tester.pumpWidget(
      MaterialApp(
        home: FlashCard(
          ontap: () {
            ontapRegistered = true;
          },
          frontGradient:
              const LinearGradient(colors: [Colors.red, Colors.blue]),
          frontWidget: const Text('What is the capital of France?'),
          backWidget: const Text('Paris'),
        ),
      ),
    );
    await tester.tap(find.byType(AnimatedCard).last, warnIfMissed: false);
    await tester.pump();
    expect(ontapRegistered, true);
  });

  testWidgets('{ width and height are applied correctly }',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LayoutBuilder(builder: (context, constraints) {
          return FlashCard(
            width: 100,
            height: 110,
            ontap: () {},
            frontGradient:
                const LinearGradient(colors: [Colors.red, Colors.blue]),
            frontWidget: const Text('What is the capital of France?'),
            backWidget: const Text('Pari'),
          );
        }),
      ),
    );
    final containerFinder = find.byType(Container).first;
    final containerRenderBox = tester.renderObject<RenderBox>(containerFinder);

    expect(
        containerRenderBox.size.height < 120 &&
            containerRenderBox.size.height > 100,
        true);
    expect(
        containerRenderBox.size.width < 110 &&
            containerRenderBox.size.height > 90,
        true);
  });
}
