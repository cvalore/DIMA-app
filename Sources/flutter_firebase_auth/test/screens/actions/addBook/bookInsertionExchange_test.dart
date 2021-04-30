import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/exchange.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Toggle of exchange flag works', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author', status: 3);

    await tester.pumpWidget(MaterialApp(home:Scaffold(body: Exchange(insertedBook: insertedBook, height: 60, justView: false))));

    expect(find.byType(Container), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsNothing);

    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsNothing);
  });

}
