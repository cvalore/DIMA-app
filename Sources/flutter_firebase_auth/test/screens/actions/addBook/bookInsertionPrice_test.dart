import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add price when inserting book', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author');

    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      PriceBox.routeName: (context) => PriceBox()
    };

    await tester.pumpWidget(MaterialApp(routes: routes, home:Price(insertedBook: insertedBook, height: 60, justView: false,)));

    expect(find.byType(Container), findsNWidgets(3));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    final PriceBoxState priceBoxState = tester.state(find.byType(PriceBox));
    assert (priceBoxState.price == null);

    await tester.enterText(find.byType(TextFormField), '60');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    assert (priceBoxState.price == '60');

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));


    expect(find.byWidgetPredicate((widget) => widget is Price && widget.insertedBook.price == 60.0), findsOneWidget);
  });

}
