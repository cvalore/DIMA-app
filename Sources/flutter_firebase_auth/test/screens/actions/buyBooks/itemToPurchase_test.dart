import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/itemToPurchase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('display item to purchase or exchange', (WidgetTester tester) async {

    InsertedBook book = InsertedBook(id: 'id', title: 'The Game', author: '[Alessandro Baricco]', status: 3,
                  imagesUrl: ['https://firebasestorage.googleapis.com/v0/b/bookyourbook-app.appspot.com/o/mgKK4plzP8OgQDhjFWdcucdNeoB2%2FThe%20Game_1%2FThe%20Game_0?alt=media&token=f32b01c0-17b8-49bf-8a66-3ca688c14883'],
                  exchangeStatus: 'available',
                  exchangeable: true,
                  insertionNumber: 1);

    ItemToPurchase itemToPurchase = ItemToPurchase(book: book, thumbnail: null, isLast: true);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: itemToPurchase)));

    expect(find.byType(Container), findsNWidgets(4));
    expect(find.byType(Divider), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'The Game'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Alessandro Baricco'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'by'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Image), findsOneWidget);
    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('display not last item to purchase or exchange', (WidgetTester tester) async {
    InsertedBook book = InsertedBook(id: 'id', title: 'The Game', author: '[Alessandro Baricco]', status: 3,
        imagesUrl: ['https://firebasestorage.googleapis.com/v0/b/bookyourbook-app.appspot.com/o/mgKK4plzP8OgQDhjFWdcucdNeoB2%2FThe%20Game_1%2FThe%20Game_0?alt=media&token=f32b01c0-17b8-49bf-8a66-3ca688c14883'],
        exchangeStatus: 'available',
        exchangeable: true,
        insertionNumber: 1);
    ItemToPurchase itemToPurchase = ItemToPurchase(book: book, thumbnail: null, isLast: false);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: itemToPurchase)));

    expect(find.byType(Container), findsNWidgets(4));
    expect(find.byType(Divider), findsOneWidget);
  });


}