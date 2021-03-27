import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add book status when inserting book', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author', status: 3);

    await tester.pumpWidget(MaterialApp(home:Scaffold(body: Status(insertedBook: insertedBook, height: 60, offset: 200, justView: false))));

    expect(find.byType(Container), findsNWidgets(7));
    expect(find.byType(IconButton), findsNWidgets(5));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNWidgets(2));

    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey(0)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNWidgets(4));
  });

}
