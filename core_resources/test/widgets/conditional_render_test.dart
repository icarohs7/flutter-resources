import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ConditionalRender using widgets', (WidgetTester tester) async {
    final visible = true.subject;
    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final isVisible = useValueStream(visible);

            return ConditionalRender(
              condition: isVisible,
              childElse: const Text('Else'),
              child: const Text('Hello'),
            );
          },
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Else'), findsNothing);

    visible.add(false);
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsNothing);
    expect(find.text('Else'), findsOneWidget);

    visible.add(true);
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Else'), findsNothing);
  });

  testWidgets('ConditionalRender using builders', (WidgetTester tester) async {
    final visible = true.subject;
    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final isVisible = useValueStream(visible);

            return ConditionalRender(
              condition: isVisible,
              childElseBuilder: (context) => const Text('Else'),
              childBuilder: (context) => const Text('Hello'),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Else'), findsNothing);

    visible.add(false);
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsNothing);
    expect(find.text('Else'), findsOneWidget);

    visible.add(true);
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Else'), findsNothing);
  });
}