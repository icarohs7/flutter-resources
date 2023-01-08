import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AutoCompleteTextView', (tester) async {
    final buttonFocus = FocusNode();
    final controller = TextEditingController();
    final suggestions = ['suggestion1', 'suggestion2', 'suggestion3', 'suggestion34'];
    var tappedSuggestion = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ElevatedButton(
                focusNode: buttonFocus,
                onPressed: () => buttonFocus.requestFocus(),
                child: Text('button'),
              ),
              AutoCompleteTextView(
                controller: controller,
                getSuggestionsMethod: (query) {
                  return suggestions.where((suggestion) => suggestion.contains(query)).toList();
                },
                onTapCallback: (suggestion) {
                  tappedSuggestion = suggestion;
                },
              ),
            ],
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'suggestion');
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('suggestion1'), findsOneWidget);
    expect(find.text('suggestion2'), findsOneWidget);
    expect(find.text('suggestion3'), findsOneWidget);
    expect(find.text('suggestion34'), findsOneWidget);

    await tester.tap(find.text('suggestion1'));
    await tester.pump(Duration(milliseconds: 300));

    expect(tappedSuggestion, 'suggestion1');
    expect(controller.text, 'suggestion1');

    await tester.enterText(find.byType(TextField), 'suggestion');
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('suggestion1'), findsOneWidget);
    expect(find.text('suggestion2'), findsOneWidget);
    expect(find.text('suggestion3'), findsOneWidget);
    expect(find.text('suggestion34'), findsOneWidget);

    await tester.tap(find.text('button'));
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('suggestion1'), findsNothing);
    expect(find.text('suggestion2'), findsNothing);
    expect(find.text('suggestion3'), findsNothing);
    expect(find.text('suggestion34'), findsNothing);

    await tester.enterText(find.byType(TextField), 'suggestion3');
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('suggestion1'), findsNothing);
    expect(find.text('suggestion2'), findsNothing);
    expect(find.text('suggestion3'), findsNWidgets(2));
    expect(find.text('suggestion34'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pump(Duration(milliseconds: 300));
    expect(find.text('suggestion1'), findsNothing);
    expect(find.text('suggestion2'), findsNothing);
    expect(find.text('suggestion3'), findsNothing);
    expect(find.text('suggestion34'), findsNothing);
  });
}
