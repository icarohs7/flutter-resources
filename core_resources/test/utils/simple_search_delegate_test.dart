import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SimpleSearchDelegate', (tester) async {
    String? result = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  result = await showSearch<String?>(
                    context: tester.element(find.byType(Scaffold)),
                    delegate: SimpleSearchDelegateImplementation(),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Text('Home Page'),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    for (int i = 0; i < 10; i++) {
      await tester.pump(Duration(milliseconds: 100));
    }

    expect(find.byIcon(Icons.backspace), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.text('test001'), findsOneWidget);
    expect(find.text('test012'), findsOneWidget);
    expect(find.text('test013'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test00');
    for (int i = 0; i < 10; i++) {
      await tester.pump(Duration(milliseconds: 100));
    }

    expect(find.byType(ListTile), findsNWidgets(1));

    await tester.tap(find.byType(ListTile).first);
    await tester.pump(Duration(milliseconds: 300));

    expect(result, 'test001');
  });

  testWidgets('SimpleSearchDelegate 2', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  await showSearch<String?>(
                    context: tester.element(find.byType(Scaffold)),
                    delegate: SimpleSearchDelegateImplementation(),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Text('Home Page'),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    for (int i = 0; i < 10; i++) {
      await tester.pump(Duration(milliseconds: 100));
    }
    await tester.enterText(find.byType(TextField), 'hellotest');

    expect(find.text('hellotest'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.backspace));

    expect(find.text('hellotest'), findsNothing);

    await tester.tap(find.byType(AnimatedIcon));
    for (int i = 0; i < 10; i++) {
      await tester.pump(Duration(milliseconds: 100));
    }

    expect(find.byIcon(Icons.backspace), findsNothing);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('test001'), findsNothing);
    expect(find.text('test012'), findsNothing);
    expect(find.text('test013'), findsNothing);
  });
}

class SimpleSearchDelegateImplementation extends SimpleSearchDelegate<String> {
  void onSearch(BuildContext context) => returnSearchResult(context, query);

  SimpleSearchDelegateImplementation({super.enableSearchButton = true});

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => returnSearchResult(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'test001',
      'test012',
      'test013',
    ].where((element) => element.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Text(item),
          leading: Icon(Icons.history),
          onTap: () => returnSearchResult(context, item),
        );
      },
    );
  }

  void returnSearchResult(BuildContext context, String result) {
    close(context, result);
  }
}
