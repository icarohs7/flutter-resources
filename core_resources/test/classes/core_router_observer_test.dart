import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late GlobalKey<NavigatorState> navigatorKey;
  late Widget defaultApp;
  final mockObserver = MockCoreRouterObserver();
  BuildContext context() => navigatorKey.currentContext!;
  final stream = CoreRouterObserver.listenable;

  setUp(() {
    registerFallbackValue(MockRoute());
    navigatorKey = GlobalKey<NavigatorState>();
    defaultApp = MaterialApp(
      navigatorKey: navigatorKey = GlobalKey<NavigatorState>(),
      navigatorObservers: [mockObserver, CoreRouterObserver()],
      routes: {
        '/': (_) => Container(),
        '/test': (_) => Container(),
        '/test2': (_) => Container(),
        '/test3': (_) => Container(),
        '/test4': (_) => Container(),
      },
    );
  });

  tearDown(() {
    reset(mockObserver);
  });

  void assertRoute(CoreRoute coreRoute, {String path = '', String? previousPath}) {
    final route = coreRoute.currentRoute;
    final previousRoute = coreRoute.previousRoute;
    expect(stream.value, coreRoute);
    expect(route.settings.name, path);
    expect(previousRoute?.settings.name, previousPath);
  }

  testWidgets('CoreRouterObserver didPush', (tester) async {
    await tester.pumpWidget(defaultApp);
    assertRoute(stream.value!, path: '/');

    Nav.to.goNamed(context(), '/test');
    await tester.pump(Duration(milliseconds: 300));
    assertRoute(stream.value!, path: '/test', previousPath: '/');
    verify(() => mockObserver.didPush(any(), any()));
  });

  testWidgets('CoreRouterObserver didReplace', (tester) async {
    await tester.pumpWidget(defaultApp);
    Nav.to.goNamed(context(), '/test');
    Nav.to.goReplacementNamed(context(), '/test2');
    await tester.pump(Duration(milliseconds: 300));
    assertRoute(stream.value!, path: '/test2', previousPath: '/test');
    verify(() {
      mockObserver.didReplace(newRoute: any(named: 'newRoute'), oldRoute: any(named: 'oldRoute'));
    });
  });

  testWidgets('CoreRouterObserver didRemove', (tester) async {
    await tester.pumpWidget(defaultApp);
    Nav.to.goNamed(context(), '/test');
    Nav.to.goNamed(context(), '/test2');
    Nav.to.goNamed(context(), '/test3');
    Nav.to.goErasingHistoryNamed(context(), '/test4');
    await tester.pump(Duration(milliseconds: 300));
    assertRoute(stream.value!, path: '/test4', previousPath: '/test3');
    verify(() => mockObserver.didRemove(any(), any()));
  });

  testWidgets('CoreRouterObserver didPop', (tester) async {
    await tester.pumpWidget(defaultApp);
    Nav.to.goNamed(context(), '/test');
    context().pop();
    await tester.pump(Duration(milliseconds: 300));
    assertRoute(stream.value!, path: '/', previousPath: '/');
    verify(() => mockObserver.didPop(any(), any()));
  });
}

class MockCoreRouterObserver extends Mock implements CoreRouterObserver {}

class MockRoute extends Route {}
