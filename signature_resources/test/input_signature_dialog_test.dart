import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signature_resources/signature_resources.dart';

void main() {
  testWidgets('renders supplied labels and forwards dialog actions', (tester) async {
    var landscapeLocks = 0;
    var portraitLocks = 0;
    var cancelCalls = 0;
    var submitCalls = 0;
    Uint8List? submittedSignature;

    await tester.pumpWidget(
      MaterialApp(
        home: InputSignatureDialog(
          title: 'Sign here',
          clearLabel: 'Clear',
          cancelLabel: 'Cancel',
          confirmLabel: 'Confirm',
          onLockOrientationToLandscape: () => landscapeLocks++,
          onLockOrientationToPortrait: () => portraitLocks++,
          onCancel: () => cancelCalls++,
          onSubmit: (signature) {
            submitCalls++;
            submittedSignature = signature;
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Sign here'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(landscapeLocks, 1);

    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(submitCalls, 1);
    expect(submittedSignature, isNull);

    await tester.pumpWidget(
      MaterialApp(
        home: InputSignatureDialog(
          title: 'Sign here',
          clearLabel: 'Clear',
          cancelLabel: 'Cancel',
          confirmLabel: 'Confirm',
          onLockOrientationToLandscape: () => landscapeLocks++,
          onLockOrientationToPortrait: () => portraitLocks++,
          onCancel: () => cancelCalls++,
          onSubmit: (signature) {
            submitCalls++;
            submittedSignature = signature;
          },
        ),
      ),
    );
    await tester.pump();
    expect(landscapeLocks, 1);
    expect(portraitLocks, 0);

    await tester.tap(find.text('Cancel'));
    expect(cancelCalls, 1);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(portraitLocks, 1);
  });
}
