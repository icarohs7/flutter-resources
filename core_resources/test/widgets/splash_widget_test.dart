import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SplashWidget', (tester) async {
    final completer = Completer<int>();
    var result = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: SplashWidget(
          child: const Text('waiting'),
          operation: (context) async {
            result++;
            context.push(MaterialPageRoute(builder: (_) => const Text('done')));
          },
        ),
      ),
    );

    expect(find.text('waiting'), findsOneWidget);
    expect(result, 0);

    completer.complete(1);
    await tester.pumpAndSettle();

    expect(find.text('waiting'), findsNothing);
    expect(result, 1);
    expect(find.text('done'), findsOneWidget);
  });
}
