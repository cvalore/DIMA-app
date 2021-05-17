import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/exchange.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Toggle of exchange flag works', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author', status: 3);
    Exchange exchangeWidget = Exchange(insertedBook: insertedBook, height: 60, justView: false);
    await tester.pumpWidget(MaterialApp(home:Scaffold(body: exchangeWidget)));

    expect(find.byType(Container), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsNothing);

    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsOneWidget);
    assert (exchangeWidget.insertedBook.exchangeable == true);

    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsNothing);
    assert (exchangeWidget.insertedBook.exchangeable == false);
  });

}
