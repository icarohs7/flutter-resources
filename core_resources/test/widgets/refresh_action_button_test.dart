import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RefreshActionButton', (WidgetTester tester) async {
    final isLoading = ValueNotifier(false);
    var count = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HookBuilder(builder: (context) {
            final loading = useValueListenable(isLoading);

            return RefreshActionButton(
              isRefreshing: loading,
              onTap: () => count++,
            );
          }),
        ),
      ),
    );

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byType(RefreshActionButton));
    isLoading.value = true;
    await tester.pump(Duration(milliseconds: 300));

    expect(find.byIcon(Icons.refresh), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(count, 1);
  });
}
