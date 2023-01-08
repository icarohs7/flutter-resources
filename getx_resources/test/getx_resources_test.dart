import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_resources/getx_resources.dart';

void main() {
  late GlobalKey<NavigatorState> navigatorKey;
  late Widget defaultApp;

  setUpAll(() async {
    await HiveDbResources.init(initHive: false);
  });

  setUp(() {
    navigatorKey = GlobalKey<NavigatorState>();
    defaultApp = GetMaterialApp(
      navigatorKey: navigatorKey,
      getPages: [
        GetPage(name: '/', page: () => Row()),
        GetPage(name: '/test', page: () => Column()),
        GetPage(name: '/test2', page: () => Container()),
      ],
    );
  });

  tearDown(() {
    Get.reset();
  });

  test('should define service locator', () {
    Get.put('test');
    Get.put(['Omai', 'Wa', 'Mou', 'Shindeiru']);
    Get.put([1, 2, 3, 4, 5]);

    expect(Core.get<String>(), 'test');
    expect(Core.get<List<String>>(), ['Omai', 'Wa', 'Mou', 'Shindeiru']);
    expect(Core.get<List<int>>(), [1, 2, 3, 4, 5]);
    expect(() => Core.get<int>(), throwsA(isA<Object>()));
  });

  testWidgets('push test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Container), findsOneWidget);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);

    Core.push(navigatorKey.currentContext!, '/test', params: {'test': 'test'});

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
    expect(currentPath, '/test?test=test');
  });

  testWidgets('go test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Container), findsOneWidget);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);

    Core.go(navigatorKey.currentContext!, '/test', params: {'test': 'test'});

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
    expect(currentPath, '/test?test=test');
  });

  testWidgets('replace test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Container), findsOneWidget);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);

    Core.replace(navigatorKey.currentContext!, '/test', params: {'test': 'test'});

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
    expect(currentPath, '/test?test=test');
  });

  testWidgets('replaceAll test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
    expect(find.byType(Container), findsOneWidget);
    expect(Navigator.of(navigatorKey.currentContext!).canPop(), isTrue);

    Core.replaceAll(navigatorKey.currentContext!, '/test', params: {'test': 'test'});

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
    expect(currentPath, '/test?test=test');
  });

  testWidgets('currentPath test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2');
    await tester.pumpAndSettle();

    expect(Core.currentPath(navigatorKey.currentContext!), '/test2');
  });

  testWidgets('currentParams test', (tester) async {
    await tester.pumpWidget(defaultApp);

    Navigator.of(navigatorKey.currentContext!).pushNamed('/test?test=test');
    Navigator.of(navigatorKey.currentContext!).pushNamed('/test2?test2=test2');
    await tester.pumpAndSettle();

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

    expect(Core.currentExtras(navigatorKey.currentContext!), 'Standing here I realize');
  });
}
