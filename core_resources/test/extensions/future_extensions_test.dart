import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should run async code catching errors", () async {
    final f1 = await runCatchingAsync(() => throw Exception("Test"));
    expect(f1.isError, true);
    expect(f1.asError.error.runtimeType, Exception("Test").runtimeType);
    expect(f1.asError.error.toString(), "Exception: Test");

    final f2 = await runCatchingAsync(() => "kono giorno giovanna niwa yume ga aru");
    expect(f2.isValue, true);
    expect(f2.asValue.value, "kono giorno giovanna niwa yume ga aru");
  });
}
