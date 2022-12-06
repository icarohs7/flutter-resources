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
      routes: {
        '/': (_) => Container(),
        '/page1': (_) => Column(),
        '/page2': (_) => Row(),
      },
    );
  });

  testWidgets('goFullscreenDialog', (tester) async {
    await tester.pumpWidget(defaultApp);
    expect(find.byType(Column), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isFalse);
    Nav.to.goFullscreenDialog(navigatorKey.currentContext!, page: Column());
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isTrue);
  });

  testWidgets('goNamed', (tester) async {
    await tester.pumpWidget(defaultApp);
    expect(find.byType(Column), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isFalse);
    Nav.to.goNamed(navigatorKey.currentContext!, '/page1');
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isTrue);
  });

  testWidgets('go', (tester) async {
    await tester.pumpWidget(defaultApp);
    expect(find.byType(Column), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isFalse);
    Nav.to.go(navigatorKey.currentContext!, page: Column());
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isTrue);
  });

  testWidgets('goReplacementNamed', (tester) async {
    await tester.pumpWidget(defaultApp);
    expect(find.byType(Column), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isFalse);
    Nav.to.goReplacementNamed(navigatorKey.currentContext!, '/page1');
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isFalse);
  });

  testWidgets('goReplacement', (tester) async {
    await tester.pumpWidget(defaultApp);
    expect(find.byType(Column), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isFalse);
    Nav.to.goReplacement(navigatorKey.currentContext!, page: Column());
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isFalse);
  });

  testWidgets('goErasingHistoryNamed', (tester) async {
    await tester.pumpWidget(defaultApp);
    Navigator.of(navigatorKey.currentContext!).pushNamed('/page2');
    expect(find.byType(Column), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isTrue);
    Nav.to.goErasingHistoryNamed(navigatorKey.currentContext!, '/page1');
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isFalse);
  });

  testWidgets('goErasingHistory', (tester) async {
    await tester.pumpWidget(defaultApp);
    Navigator.of(navigatorKey.currentContext!).pushNamed('/page2');
    expect(find.byType(Column), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isTrue);
    Nav.to.goErasingHistory(navigatorKey.currentContext!, page: Column());
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isFalse);
  });
}
