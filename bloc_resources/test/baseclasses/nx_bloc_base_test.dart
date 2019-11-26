import 'package:bloc_pattern/bloc_pattern_test.dart';
import 'package:bloc_resources/bloc_resources.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_module.dart';

void main() {
  initModule(TestModule());
  NxBlocBase bloc;

  setUp(() {
    bloc = TestModule.to.bloc<NxBlocBase>();
  });

  test("should indicate loading", () {
    expect(bloc.isLoading, false);
    bloc.toggleLoading(true);
    expect(bloc.isLoading, true);
  });
}
