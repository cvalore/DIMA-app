import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/purchases.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view my purchased books from my orders', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    Timestamp time = Timestamp.now();
    Map<String, dynamic> purchase = {'title': 'The Game', 'author': '[Alessandro Baricco]', 'chosenShippingMode': 'express courier',
    'price': 12.0, 'time': time};

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    await tester.pumpWidget(MaterialApp(home: Purchases(purchases: [purchase])));

    expect(find.text('The Game'), findsOneWidget);
    expect(find.text('Alessandro Baricco'), findsOneWidget);
    expect(find.text('12.00 €'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);

  });

  testWidgets('enter my purchased books section with no purchased books', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    await tester.pumpWidget(MaterialApp(home: Purchases()));

    expect(find.text('All your completed purchases will appear here!'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.shopping_cart_outlined), findsOneWidget);

  });

}