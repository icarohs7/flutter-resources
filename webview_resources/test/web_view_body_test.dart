import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:webview_resources/webview_resources.dart';

void main() {
  testWidgets('renders the injected error label when the controller is unavailable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WebViewBody(
          controller: null,
          loadingProgress: 100,
          errorLabel: 'Unable to load the page',
        ),
      ),
    );

    expect(find.text('Unable to load the page'), findsOneWidget);
  });

  testWidgets('prefers the custom error child over the injected label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WebViewBody(
          controller: null,
          loadingProgress: 100,
          errorLabel: 'Unable to load the page',
          loadErrorChild: Text('Try again'),
        ),
      ),
    );

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Unable to load the page'), findsNothing);
  });
}
