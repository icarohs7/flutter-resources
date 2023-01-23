import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_resources/getx_resources.dart';

void main() {
  testWidgets('obsF', (tester) async {
    final completer = Completer<int>();

    final obs = completer.future.obsF();

    expect(obs.value, isNull);

    await tester.pumpWidget(
      Obx(() {
        final value = obs.value;
        return Text(value.toString(), textDirection: TextDirection.ltr);
      }),
    );

    expect(find.text('null'), findsOneWidget);

    completer.complete(42);

    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('42'), findsOneWidget);
    expect(obs.value, 42);
  });
}
