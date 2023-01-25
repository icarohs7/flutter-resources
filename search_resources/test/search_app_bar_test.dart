import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_resources/src/search_app_bar.dart';

void main() {
  group('SearchAppBar', () {
    testWidgets('should open search', (tester) async {
      //arrange
      await tester.pumpWidget(MaterialApp(
        home: SearchAppBar(
          title: Text('Title'),
          actions: const [
            Icon(Icons.refresh),
          ],
          onSearchChange: (String query) {},
        ),
      ));
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Pesquisa'), findsNothing);
      //act
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      //assert
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.search), findsNothing);
      expect(find.text('Title'), findsNothing);
      expect(find.text('Pesquisa'), findsOneWidget);
    });

    testWidgets('should emit query change events', (tester) async {
      //arrange
      var query = '';
      await tester.pumpWidget(MaterialApp(
        home: SearchAppBar(
          title: Text('Title'),
          actions: const [
            Icon(Icons.refresh),
          ],
          onSearchChange: (String newQuery) => query = newQuery,
        ),
      ));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      //act
      await tester.enterText(find.byType(TextField), 'query');
      await tester.pumpAndSettle();
      //assert
      expect(query, 'query');
    });

    testWidgets('should clear query', (tester) async {
      //arrange
      var query = '';
      await tester.pumpWidget(MaterialApp(
        home: SearchAppBar(
          title: Text('Title'),
          actions: const [
            Icon(Icons.refresh),
          ],
          onSearchChange: (String newQuery) => query = newQuery,
        ),
      ));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'query');
      await tester.pumpAndSettle();
      //act
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      //assert
      expect(query, '');
    });

    testWidgets('should close search', (tester) async {
      //arrange
      await tester.pumpWidget(MaterialApp(
        home: SearchAppBar(
          title: Text('Title'),
          actions: const [
            Icon(Icons.refresh),
          ],
          onSearchChange: (String query) {},
        ),
      ));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      //act
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      //assert
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Pesquisa'), findsNothing);
    });
  });
}
