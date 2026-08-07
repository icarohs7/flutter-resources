import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('preserves external controller behavior', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final isEditable = ValueNotifier(false);
    var saved = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HookBuilder(builder: (context) {
            final editable = useValueListenable(isEditable);

            return EditableLabel(
              controller: controller,
              editable: editable,
              labelText: 'label',
              onSave: () => saved = true,
              animationDuration: Duration.zero,
              enabled: null,
            );
          }),
        ),
      ),
    );

    TextFormField getFormField() => tester.widget(find.byType(TextFormField));

    expect(getFormField().enabled, false);
    expect(find.text('label'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsNothing);
    expect(find.byIcon(Icons.save), findsNothing);

    isEditable.value = true;
    await tester.pump(Duration(milliseconds: 600));

    expect(getFormField().enabled, false);
    expect(find.text('label'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.save), findsNothing);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump(Duration(milliseconds: 600));

    expect(getFormField().enabled, true);
    expect(find.text('label'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsNothing);
    expect(find.byIcon(Icons.save), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'test');

    expect(saved, false);
    expect(controller.text, 'test');

    await tester.tap(find.byIcon(Icons.save));
    await tester.pump(Duration(milliseconds: 600));

    expect(getFormField().enabled, false);
    expect(saved, true);
    expect(find.text('label'), findsOneWidget);
    expect(find.text('test'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.save), findsNothing);

    await tester.pumpWidget(const SizedBox());
    controller.text = 'after';

    expect(controller.text, 'after');
  });

  testWidgets('renders value with an owned controller', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditableLabel(
            value: 'shown',
            editable: false,
          ),
        ),
      ),
    );

    final field = tester.widget<TextFormField>(find.byType(TextFormField));

    expect(field.controller?.text, 'shown');
  });

  testWidgets('updates the owned controller when value changes', (tester) async {
    final value = ValueNotifier('first');
    addTearDown(value.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<String>(
            valueListenable: value,
            builder: (context, currentValue, child) {
              return EditableLabel(
                value: currentValue,
                editable: false,
              );
            },
          ),
        ),
      ),
    );

    TextFormField getFormField() => tester.widget(find.byType(TextFormField));

    expect(getFormField().controller?.text, 'first');

    value.value = 'second';
    await tester.pump();

    expect(getFormField().controller?.text, 'second');
  });

  testWidgets('preserves initialValue compatibility', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditableLabel(
            initialValue: 'initial',
            editable: false,
          ),
        ),
      ),
    );

    final field = tester.widget<TextFormField>(find.byType(TextFormField));

    expect(field.initialValue, 'initial');
    expect(field.controller, isNull);
  });

  test('rejects value with an external controller', () {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    expect(
      () => EditableLabel(value: 'value', controller: controller),
      throwsA(isA<AssertionError>()),
    );
  });

  test('rejects value with initialValue', () {
    expect(
      () => EditableLabel(value: 'value', initialValue: 'initial'),
      throwsA(isA<AssertionError>()),
    );
  });
}
