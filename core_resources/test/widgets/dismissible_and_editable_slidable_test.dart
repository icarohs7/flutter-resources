import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DismissibleAndEditableSlidable', (tester) async {
    var dismissed = false;
    var edited = false;
    var confirmedDismiss = false;
    final widget = MaterialApp(
      home: DismissibleAndEditableSlidable(
        itemKey: Key('itemKey'),
        onDismissed: () => dismissed = true,
        onEdited: () => edited = true,
        confirmDismiss: () async => confirmedDismiss,
        child: Text('child'),
      ),
    );

    expect(dismissed, false);
    expect(edited, false);
    expect(confirmedDismiss, false);

    await tester.pumpWidget(widget);
    await tester.drag(find.byType(Dismissible), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(dismissed, false);
    expect(edited, true);
    expect(confirmedDismiss, false);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(dismissed, false);
    expect(edited, true);
    expect(confirmedDismiss, false);

    confirmedDismiss = true;
    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(dismissed, true);
    expect(edited, true);
    expect(confirmedDismiss, true);
  });
}
