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
      initialRoute: '/',
      routes: {
        '/': (_) => Row(),
        '/test': (_) => Column(),
        '/test2': (_) => Container(),
      },
    );
  });

  test('should define service locator', () {
    final locatorMap = <Type, Object>{
      String: 'test',
      List<String>: ['Omai', 'Wa', 'Mou', 'Shindeiru'],
      List<int>: [1, 2, 3, 4, 5],
    };

    expect(() => Core.get(), throwsA(isA<Error>()));
    Core.setLocator(<T extends Object>() => locatorMap[T] as T);
    expect(Core.get<String>(), 'test');
    expect(Core.get<List<String>>(), ['Omai', 'Wa', 'Mou', 'Shindeiru']);
    expect(Core.get<List<int>>(), [1, 2, 3, 4, 5]);
    expect(() => Core.get<int>(), throwsA(isA<Error>()));
  });

  testWidgets('replaceAllNamedNavigator test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Container), findsOneWidget);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);
    expect(() => Core.replaceAllNamed(navigatorKey.currentContext!, '/'), throwsA(isA<Error>()));

    Core.setReplaceAllNamedFn((context, routeName, {params, extra}) {
      Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false, arguments: params);
    });
    Core.replaceAllNamed(navigatorKey.currentContext!, '/test', params: {'test': 'test'});

    await tester.pumpAndSettle();
    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Container), findsNothing);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isFalse);

    String? currentPath;
    Object? arguments;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      arguments = route.settings.arguments;
      return true;
    });
    expect(currentPath, '/test');
    expect(arguments, {'test': 'test'});
  });

  testWidgets('replaceNamedNavigator test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Container), findsOneWidget);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);
    expect(() => Core.replaceNamed(navigatorKey.currentContext!, '/'), throwsA(isA<Error>()));

    Core.setReplaceNamedFn((context, routeName, {params, extra}) {
      Navigator.of(context).pushReplacementNamed(routeName, arguments: params);
    });
    Core.replaceNamed(navigatorKey.currentContext!, '/test', params: {'test': 'test'});

    await tester.pumpAndSettle();
    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Container), findsNothing);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);

    String? currentPath;
    Object? arguments;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      arguments = route.settings.arguments;
      return true;
    });
    expect(currentPath, '/test');
    expect(arguments, {'test': 'test'});
  });

  testWidgets('goNamedNavigator test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Container), findsOneWidget);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);
    expect(() => Core.goNamed(navigatorKey.currentContext!, '/'), throwsA(isA<Error>()));

    Core.setGoNamedFn((context, routeName, {params, extra}) {
      Navigator.of(context).pushNamed(routeName, arguments: params);
    });
    Core.goNamed(navigatorKey.currentContext!, '/test', params: {'test': 'test'});

    await tester.pumpAndSettle();
    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Container), findsNothing);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);

    String? currentPath;
    Object? arguments;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      arguments = route.settings.arguments;
      return true;
    });
    expect(currentPath, '/test');
    expect(arguments, {'test': 'test'});
  });

  testWidgets('currentPath test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(() => Core.currentPath(navigatorKey.currentContext!), throwsA(isA<Error>()));
    Core.setCurrentPathFn((context) {
      String? currentPath;
      navigatorKey.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });
      return currentPath!;
    });
    expect(Core.currentPath(navigatorKey.currentContext!), '/test2');
  });

  testWidgets('currentParams test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test', arguments: {'test': 'test'});
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2', arguments: {'test2': 'test2'});
    await tester.pumpAndSettle();

    expect(() => Core.currentParams(navigatorKey.currentContext!), throwsA(isA<Error>()));
    Core.setCurrentParamsFn((context) {
      Object? arguments;
      navigatorKey.currentState?.popUntil((route) {
        arguments = route.settings.arguments;
        return true;
      });
      return arguments! as Map<String, String>;
    });
    expect(Core.currentParams(navigatorKey.currentContext!), {'test2': 'test2'});
  });

  testWidgets('currentExtras test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed(
      '/test',
      arguments: 'Hello, is it me you\'re looking for?',
    );
    Navigator.of(navigatorKey.currentContext!).pushNamed(
      '/test2',
      arguments: 'Standing here I realize',
    );
    await tester.pumpAndSettle();

    expect(() => Core.currentExtras(navigatorKey.currentContext!), throwsA(isA<Error>()));
    Core.setCurrentExtrasFn((context) {
      Object? arguments;
      navigatorKey.currentState?.popUntil((route) {
        arguments = route.settings.arguments;
        return true;
      });
      return arguments!;
    });
    expect(Core.currentExtras(navigatorKey.currentContext!), 'Standing here I realize');
  });
}
