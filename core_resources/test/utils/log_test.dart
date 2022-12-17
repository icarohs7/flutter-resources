import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('clog', () async {
    final logs = <String>[];

    await runZoned(() async {
      clog('Hello');
    }, zoneSpecification: ZoneSpecification(print: (self, parent, zone, line) {
      logs.add(line);
    }));

    expect(logs, ['Hello']);

    // TODO: how to mock a release environment?
  });
}
