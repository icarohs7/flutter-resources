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
              onConfirm: (context) => Navigator.pop(context),
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

  group('showConfirmDialog', () {
    var result = false;
    var confirmed = false;
    var cancelled = false;
    final widget = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showConfirmDialog(
                context,
                title: Text('title'),
                content: Text('content'),
                confirmText: 'confirmTest',
                onConfirm: (_) {
                  confirmed = true;
                  context.pop(true);
                },
                cancelText: 'cancelTest',
                onCancel: (_) {
                  cancelled = true;
                  context.pop();
                },
              );
            },
            child: const Text('Show'),
          ),
        ),
      ),
    );

    testWidgets('dialog opens', (tester) async {
      await tester.pumpWidget(widget);
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('title'), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
      expect(find.text('confirmTest'), findsOneWidget);
      expect(find.text('cancelTest'), findsOneWidget);

      result = false;
      confirmed = false;
      cancelled = false;
    });

    testWidgets('cancel button pressed', (tester) async {
      await tester.pumpWidget(widget);
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('cancelTest'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
      expect(confirmed, isFalse);
      expect(cancelled, isTrue);
      expect(find.text('title'), findsNothing);
      expect(find.text('content'), findsNothing);
      expect(find.text('confirmTest'), findsNothing);
      expect(find.text('cancelTest'), findsNothing);

      result = false;
      confirmed = false;
      cancelled = false;
    });

    testWidgets('confirm button pressed', (tester) async {
      await tester.pumpWidget(widget);
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('confirmTest'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
      expect(confirmed, isTrue);
      expect(cancelled, isFalse);
      expect(find.text('title'), findsNothing);
      expect(find.text('content'), findsNothing);
      expect(find.text('confirmTest'), findsNothing);
      expect(find.text('cancelTest'), findsNothing);

      result = false;
      confirmed = false;
      cancelled = false;
    });
  });

  testWidgets('showConfirmDialog with default values', (tester) async {
    var result = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showConfirmDialog(
                  context,
                  title: Text('title'),
                  confirmText: 'confirmTest',
                  cancelText: 'cancelTest',
                );
              },
              child: const Text('Show dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    expect(find.text('title'), findsOneWidget);
    expect(find.text('content'), findsNothing);
    expect(find.text('confirmTest'), findsOneWidget);
    expect(find.text('cancelTest'), findsOneWidget);

    await tester.tap(find.text('cancelTest'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
    expect(find.text('title'), findsNothing);
    expect(find.text('content'), findsNothing);
    expect(find.text('confirmTest'), findsNothing);
    expect(find.text('cancelTest'), findsNothing);

    await tester.tap(find.text('Show dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('confirmTest'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.text('title'), findsNothing);
    expect(find.text('content'), findsNothing);
    expect(find.text('confirmTest'), findsNothing);
    expect(find.text('cancelTest'), findsNothing);
  });

  test('createMaterialColor', () {
    const c1 = Color(0xFF174378);
    final m1 = createMaterialColor(c1);

    expect(m1, isNotNull);
    expect(m1.toARGB32(), c1.toARGB32());
    expect(m1[50]!.toARGB32(), equals(Color(0xFF7F98B5).toARGB32()));
    expect(m1[100]!.toARGB32(), equals(Color(0xFF748EAE).toARGB32()));
    expect(m1[200]!.toARGB32(), equals(Color(0xFF5D7BA1).toARGB32()));
    expect(m1[300]!.toARGB32(), equals(Color(0xFF456993).toARGB32()));
    expect(m1[400]!.toARGB32(), equals(Color(0xFF2E5685).toARGB32()));
    expect(m1[500]!.toARGB32(), equals(Color(0xFF174378).toARGB32()));
    expect(m1[600]!.toARGB32(), equals(Color(0xFF153C6C).toARGB32()));
    expect(m1[700]!.toARGB32(), equals(Color(0xFF123660).toARGB32()));
    expect(m1[800]!.toARGB32(), equals(Color(0xFF102F54).toARGB32()));
    expect(m1[900]!.toARGB32(), equals(Color(0xFF0E2848).toARGB32()));
  });
}
