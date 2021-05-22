import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/viewBoughtItemPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view bought book from my orders', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    Timestamp time = Timestamp.now();
    Map<String, dynamic> transactionInfo = {'sellerUsername': 'Manuel', 'chosenShippingMode': 'express courier',
      'payCash': false, 'shippingAddress': {'address 1': 'via G.Longo'}, 'time': time};
    InsertedBook boughtBook = InsertedBook(title: 'Una giornata nell vecchia Roma', author: '[Alberto Angela]', status: 2, price: 12.0, category: 'Essay');

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    await tester.pumpWidget(MaterialApp(home: ViewBoughtItemPage(boughtBook: boughtBook, transactionsInfo: transactionInfo)));

    expect(find.text('NO IMAGE AVAILABLE'), findsOneWidget);
    expect(find.text('Una giornata nell vecchia Roma'), findsOneWidget);

    expect(find.text('Alberto Angela'), findsOneWidget);
    expect(find.text('Author'), findsOneWidget);
    expect(find.text('Essay'), findsOneWidget);
    expect(find.text('12.00 €'), findsOneWidget);
    expect(find.text('Manuel'), findsOneWidget);
    expect(find.text('express courier'), findsOneWidget);
    expect(find.text('via G.Longo'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNWidgets(3));


  });

}