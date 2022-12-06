import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GlobalKey<NavigatorState> navigatorKey;
  late Widget defaultApp;
  setUp(() {
    navigatorKey = GlobalKey<NavigatorState>();
    defaultApp = MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Container(),
      ),
    );
  });

  testWidgets('should return scaffoldMessenger', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    expect(context.scaffoldMessenger, isA<ScaffoldMessengerState>());
    expect(context.scaffoldMessenger, ScaffoldMessenger.of(context));
  });

  testWidgets('should show snackbar', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    final snackBar = SnackBar(content: Text('test'));
    final scaffoldFeatureController = context.showSnackbar(snackBar);
    expect(
      scaffoldFeatureController,
      isA<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>(),
    );
  });

  testWidgets('should return if system is on dark mode', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    expect(context.isSystemDarkTheme, isA<bool>());
    expect(context.isSystemDarkTheme, MediaQuery.of(context).platformBrightness == Brightness.dark);
  });

  testWidgets('should return if theme is on dark mode', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    expect(context.isDarkTheme, isA<bool>());
    expect(context.isDarkTheme, Theme.of(context).brightness == Brightness.dark);
  });
}
