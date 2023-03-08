import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_resources/search_resources.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  pump(WidgetTester tester,{int times = 10}) async {
    for (int i = 0; i < times; i++) {
      await tester.pump(Duration(milliseconds: 100));
    }
  }

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
    await pump(tester);

    expect(find.byIcon(Icons.backspace), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.text('test001'), findsOneWidget);
    expect(find.text('test012'), findsOneWidget);
    expect(find.text('test013'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test00');
    await pump(tester);

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
    await pump(tester);
    await tester.enterText(find.byType(TextField), 'hellotest');

    expect(find.text('hellotest'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.tap(find.byIcon(Icons.backspace));

    expect(find.text('hellotest'), findsNothing);

    await tester.tap(find.byType(AnimatedIcon));
    await pump(tester);

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
