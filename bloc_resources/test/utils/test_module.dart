import 'package:bloc_resources/bloc_resources.dart';
import 'package:flutter/material.dart';

class TestModule extends ModuleWidget {
  @override
  List<Bloc> get blocs {
    return [
      Bloc((i) => NxBlocBase()),
    ];
  }

  @override
  Widget get view => Container();

  @override
  List<Dependency> get dependencies => [];

  static Inject get to => Inject<TestModule>.of();
}
