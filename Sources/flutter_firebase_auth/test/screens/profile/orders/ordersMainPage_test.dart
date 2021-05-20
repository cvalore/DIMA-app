import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/exchanges.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/ordersMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/purchases.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/viewBoughtItemPage.dart';
import 'package:flutter_firebase_auth/screens/profile/paymentInfo/savedPaymentMethod.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view my orders', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    await tester.pumpWidget(MaterialApp(home: OrdersMainPage()));

    expect(find.byType(Tab), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.shopping_cart_outlined), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.compare_arrows_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.pending_outlined), findsOneWidget);

    expect(find.text('Purchases'), findsOneWidget);
    expect(find.text('Exchanges'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);

    expect(find.text('All your completed purchases will appear here!'), findsOneWidget);
    await tester.tap(find.text('Exchanges'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('All your completed purchases will appear here!'), findsNothing);
    expect(find.text('All your accepted exchanges will appear here!'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_circle_outline), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.cancel_outlined), findsOneWidget);

    await tester.tap(find.text('Rejected'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('All your accepted exchanges will appear here!'), findsNothing);
    expect(find.text('All your rejected exchanges will appear here!'), findsOneWidget);

    await tester.tap(find.text('Pending'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('All your rejected exchanges will appear here!'), findsNothing);
    expect(find.text('All your pending exchanges will appear here!'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.pending_outlined), findsNWidgets(2));





  });

 }