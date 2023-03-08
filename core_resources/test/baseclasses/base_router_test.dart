import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final BaseRouter router = RouterImpl();

  test('push', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setPushFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.push(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'route');
    expect(paramsE, {'param': 'value'});
    expect(extraE, 'extra');
  });

  test('go', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setGoFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.go(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'route');
    expect(paramsE, {'param': 'value'});
    expect(extraE, 'extra');
  });

  test('replace', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setReplaceFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.replace(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'route');
    expect(paramsE, {'param': 'value'});
    expect(extraE, 'extra');
  });

  test('replaceAll', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setReplaceAllFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.replaceAll(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'route');
    expect(paramsE, {'param': 'value'});
    expect(extraE, 'extra');
  });

  test('bottomNavRoutes', () {
    expect(router.bottomNavRoutes, ['test1', 'test2']);
  });

  test('currentBottomNavIndex', () {
    Core.setCurrentPathFn((context) => 'test2');
    expect(router.currentBottomNavIndex(MockContext()), 1);
    Core.setCurrentPathFn((context) => 'test3');
    expect(router.currentBottomNavIndex(MockContext()), null);
  });

  test('pushToBottomNavRoute', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setPushFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.pushToBottomNavRoute(MockContext(), 1);
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'test2');
    expect(paramsE, null);
    expect(extraE, null);
  });

  test('goToBottomNavRoute', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setGoFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.goToBottomNavRoute(MockContext(), 1);
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'test2');
    expect(paramsE, null);
    expect(extraE, null);
  });

  test('replaceToBottomNavRoute', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setReplaceFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.replaceToBottomNavRoute(MockContext(), 1);
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'test2');
    expect(paramsE, null);
    expect(extraE, null);
  });

  test('replaceAllToBottomNavRoute', () {
    late BuildContext contextE;
    late String routeNameE;
    Map<String, String>? paramsE;
    Object? extraE;
    Core.setReplaceAllFn((context, routeName, {params, extra}) {
      contextE = context;
      routeNameE = routeName;
      paramsE = params;
      extraE = extra;
    });
    router.replaceAllToBottomNavRoute(MockContext(), 1);
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'test2');
    expect(paramsE, null);
    expect(extraE, null);
  });
}

class RouterImpl with BaseRouter {
  @override
  List<String> get bottomNavRoutes => [
        'test1',
        'test2',
      ];
}

class MockContext extends Mock implements BuildContext {}
