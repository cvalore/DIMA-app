import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/viewBoughtItemPage.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/viewExchangedItemPage.dart';
import 'package:flutter_firebase_auth/screens/profile/paymentInfo/savedPaymentMethod.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view exchanged book from my orders', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    Timestamp time = Timestamp.now();
    Map<String, dynamic> transactionInfo = {'sellerUsername': 'Manuel', 'chosenShippingMode': 'express courier',
      'payCash': false, 'shippingAddress': {'address 1': 'via G.Longo'}, 'time': time};
    InsertedBook receivedBook = InsertedBook(title: 'Una giornata nell vecchia Roma', author: '[Alberto Angela]', status: 2, category: 'Essay');
    InsertedBook offeredBook = InsertedBook(title: 'Emmaus', author: '[Alessandro Baricco]', status: 4, category: 'Romance');

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    await tester.pumpWidget(MaterialApp(home: ViewExchangedItemPage(receivedBook: receivedBook, offeredBook: offeredBook,
        transactionsInfo: transactionInfo, type: 'Accepted')));

    expect(find.text('NO IMAGE AVAILABLE'), findsOneWidget);
    expect(find.text('Una giornata nell vecchia Roma'), findsOneWidget);
    expect(find.text('Alberto Angela'), findsOneWidget);
    expect(find.text('Essay'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNWidgets(3));

    expect(find.byType(ManuallyCloseableExpansionTile), findsNWidgets(3));
    expect(find.text('Received book'), findsOneWidget);
    await tester.tap(find.text('Received book'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('NO IMAGE AVAILABLE'), findsNothing);
    expect(find.text('Una giornata nell vecchia Roma'), findsNothing);
    expect(find.text('Alberto Angela'), findsNothing);
    expect(find.text('Essay'), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNothing);

    expect(find.text('Offered book'), findsOneWidget);
    await tester.tap(find.text('Offered book'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('NO IMAGE AVAILABLE'), findsOneWidget);
    expect(find.text('Emmaus'), findsOneWidget);
    expect(find.text('Alessandro Baricco'), findsOneWidget);
    expect(find.text('Romance'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsOneWidget);

    expect(find.text('Offered book'), findsOneWidget);
    await tester.tap(find.text('Offered book'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('Manuel'), findsOneWidget);
    expect(find.text('express courier'), findsOneWidget);

  });

}