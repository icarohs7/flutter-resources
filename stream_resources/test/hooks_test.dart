import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_resources/stream_resources.dart';

void main() {
  testWidgets('useValueStream test', (tester) async {
    final subject = 0.subject;

    await tester.pumpWidget(
      MaterialApp(
        home: HookBuilder(
          builder: (context) {
            final value = useValueStream(subject);
            return Text(value.toString());
          },
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    subject.add(1);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
