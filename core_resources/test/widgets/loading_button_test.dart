import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoadingElevatedButton', (WidgetTester tester) async {
    final isLoading = ValueNotifier(false);
    var count = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HookBuilder(builder: (context) {
              final loading = useValueListenable(isLoading);

              return LoadingElevatedButton(
                onPressed: () => count++,
                isLoading: loading,
                child: const Text('Test'),
              );
            }),
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoading.value = true;
    await tester.pump(Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoading.value = false;
    await tester.pump(Duration(milliseconds: 300));
    await tester.tap(find.byType(LoadingElevatedButton));
    expect(count, 1);
  });

  testWidgets('LoadingFilledButton', (WidgetTester tester) async {
    final isLoading = ValueNotifier(false);
    var count = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HookBuilder(builder: (context) {
              final loading = useValueListenable(isLoading);

              return LoadingFilledButton(
                onPressed: () => count++,
                isLoading: loading,
                child: const Text('Test'),
              );
            }),
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoading.value = true;
    await tester.pump(Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoading.value = false;
    await tester.pump(Duration(milliseconds: 300));
    await tester.tap(find.byType(LoadingFilledButton));
    expect(count, 1);
  });

  testWidgets('LoadingTextButton', (WidgetTester tester) async {
    final isLoading = ValueNotifier(false);
    var count = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HookBuilder(builder: (context) {
              final loading = useValueListenable(isLoading);

              return LoadingTextButton(
                onPressed: () => count++,
                isLoading: loading,
                child: const Text('Test'),
              );
            }),
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoading.value = true;
    await tester.pump(Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoading.value = false;
    await tester.pump(Duration(milliseconds: 300));
    await tester.tap(find.byType(LoadingTextButton));
    expect(count, 1);
  });

  testWidgets('LoadingFloatingActionButton', (WidgetTester tester) async {
    final isLoading = ValueNotifier(false);
    var count = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HookBuilder(builder: (context) {
              final loading = useValueListenable(isLoading);

              return LoadingFloatingActionButton(
                onPressed: () => count++,
                isLoading: loading,
                child: const Text('Test'),
              );
            }),
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoading.value = true;
    await tester.pump(Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoading.value = false;
    await tester.pump(Duration(milliseconds: 300));
    await tester.tap(find.byType(LoadingFloatingActionButton));
    expect(count, 1);
  });

  testWidgets('LoadingIconButton', (WidgetTester tester) async {
    final isLoading = ValueNotifier(false);
    var count = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HookBuilder(builder: (context) {
              final loading = useValueListenable(isLoading);

              return LoadingIconButton(
                onPressed: () => count++,
                isLoading: loading,
                icon: const Icon(Icons.add),
              );
            }),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoading.value = true;
    await tester.pump(Duration(milliseconds: 300));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoading.value = false;
    await tester.pump(Duration(milliseconds: 300));
    await tester.tap(find.byType(LoadingIconButton));
    expect(count, 1);
  });
}
