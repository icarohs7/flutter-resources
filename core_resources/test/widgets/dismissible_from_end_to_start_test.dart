import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DismissibleFromEndToStart', (tester) async {
    var dismissed = false;
    var confirmed = false;
    final widget = MaterialApp(
      home: DismissibleFromEndToStart(
        itemKey: Key('itemKey'),
        onDismissed: () => dismissed = true,
        confirmDismiss: () async => confirmed,
        child: Text('child'),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(dismissed, false);
    expect(confirmed, false);

    confirmed = true;
    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(dismissed, true);
    expect(confirmed, true);
  });
}
