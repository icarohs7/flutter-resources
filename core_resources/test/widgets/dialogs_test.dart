import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SimpleAlert using custom text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return TextButton(
          onPressed: () {
            showSimpleAlert(
              context,
              title: Text('Title'),
              content: Text('Content'),
              confirmText: 'Confirm',
              onConfirm: () => Navigator.pop(context),
            );
          },
          child: Text('Show dialog'),
        );
      }),
    ));

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsNothing);
    expect(find.text('Content'), findsNothing);
    expect(find.text('Confirm'), findsNothing);

  });

  testWidgets('SimpleAlert using default text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return TextButton(
          onPressed: () {
            showSimpleAlert(
              context,
              title: Text('Title'),
              content: Text('Content'),
            );
          },
          child: Text('Show dialog'),
        );
      }),
    ));

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Ok'), findsOneWidget);

    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsNothing);
    expect(find.text('Content'), findsNothing);
    expect(find.text('Ok'), findsNothing);

  });
}
