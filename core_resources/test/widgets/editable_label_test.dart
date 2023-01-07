import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EditableLabel', (tester) async {
    final controller = TextEditingController();
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
  });
}
