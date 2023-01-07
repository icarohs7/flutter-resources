import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PasswordFormField', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordFormField(
            obscuringCharacter: '-',
            controller: controller,
          ),
        ),
      ),
    );

    TextField getField() => tester.widget(find.byType(TextField));

    await tester.enterText(find.byType(TextFormField), 'p');
    await tester.pump(Duration(milliseconds: 300));

    expect(controller.text, 'p');
    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(getField().obscureText, true);

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump(Duration(milliseconds: 300));

    expect(getField().obscureText, false);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump(Duration(milliseconds: 300));

    expect(getField().obscureText, true);
  });
}
