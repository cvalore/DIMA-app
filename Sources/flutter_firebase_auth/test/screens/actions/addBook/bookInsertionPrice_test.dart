import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add price when inserting book', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author');

    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      PriceBox.routeName: (context) => PriceBox()
    };

    Price priceWidget = Price(insertedBook: insertedBook, height: 60, justView: false);

    await tester.pumpWidget(MaterialApp(routes: routes, home: Scaffold(body: priceWidget)));

    expect(find.byType(Container), findsNWidgets(3));
    expect(find.byType(InkWell), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);

    await tester.tap(find.byType(InkWell));
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

    //type again on price
    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    assert (priceBoxState.price == '60.0');
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Enter a valid price'), findsNothing);

    await tester.enterText(find.byType(TextFormField), '0.00');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Enter a valid price'), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Enter a valid price'), findsNothing);

    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextFormField), '7.5555');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Enter a valid price'), findsOneWidget);



  });

}
