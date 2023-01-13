import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NumberStepper', (WidgetTester tester) async {
    final number = ValueNotifier(0);
    late NumberStepperEvent lastEvent;
    var count = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HookBuilder(builder: (context) {
            final numberValue = useValueListenable(number);

            return NumberStepper(
              numberValue,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              onChange: (value, event) {
                if (event == NumberStepperEvent.increase) {
                  number.value = value + 1;
                } else {
                  number.value = value - 1;
                }
                lastEvent = event;
                count++;
              },
            );
          }),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('1'), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(lastEvent, NumberStepperEvent.increase);
    expect(count, 1);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('0'), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(lastEvent, NumberStepperEvent.decrease);
    expect(count, 2);
  });
}
