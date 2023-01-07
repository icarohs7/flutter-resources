import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
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
    MockRouter().push(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
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
    MockRouter().go(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
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
    MockRouter().replace(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
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
    MockRouter().replaceAll(MockContext(), 'route', params: {'param': 'value'}, extra: 'extra');
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'route');
    expect(paramsE, {'param': 'value'});
    expect(extraE, 'extra');
  });

  test('bottomNavRoutes', () {
    expect(MockRouter().bottomNavRoutes, ['test1', 'test2']);
  });

  test('currentBottomNavIndex', () {
    Core.setCurrentPathFn((context) => 'test2');
    expect(MockRouter().currentBottomNavIndex(MockContext()), 1);
    Core.setCurrentPathFn((context) => 'test3');
    expect(MockRouter().currentBottomNavIndex(MockContext()), null);
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
    MockRouter().pushToBottomNavRoute(MockContext(), 1);
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
    MockRouter().goToBottomNavRoute(MockContext(), 1);
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
    MockRouter().replaceToBottomNavRoute(MockContext(), 1);
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
    MockRouter().replaceAllToBottomNavRoute(MockContext(), 1);
    expect(contextE, isA<MockContext>());
    expect(routeNameE, 'test2');
    expect(paramsE, null);
    expect(extraE, null);
  });
}

class MockRouter with BaseRouter {
  @override
  List<String> get bottomNavRoutes => [
        'test1',
        'test2',
      ];
}

class MockContext extends Mock implements BuildContext {}
