import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/exchanges.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view my exchanges from my orders', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    Timestamp time = Timestamp.now();
    Map<String, dynamic> exchange = {'receivedBook': {'title': 'The Game', 'author': '[Alessandro Baricco]'},
      'offeredBook': {'title': '1Q84', 'author': '[Haruki Murakami]'}, 'time': time};

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    await tester.pumpWidget(MaterialApp(home: Exchanges(exchanges: [exchange])));

    expect(find.text('The Game'), findsOneWidget);
    expect(find.text('Alessandro Baricco'), findsOneWidget);
    expect(find.text('1Q84'), findsOneWidget);
    expect(find.text('Haruki Murakami'), findsOneWidget);
    expect(find.text('exchanged for my '), findsOneWidget);
    expect(find.text('by\t\t '), findsNWidgets(2));
    expect(find.byType(Card), findsOneWidget);

  });

  testWidgets('enter my exchanged books section with no exchanged books', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    String type = 'Accepted';
    await tester.pumpWidget(MaterialApp(home: Exchanges(type: type)));

    expect(find.text('All your accepted exchanges will appear here!'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.compare_arrows_outlined), findsOneWidget);

    type = 'Pending';
    await tester.pumpWidget(MaterialApp(home: Exchanges(type: type)));

    expect(find.text('All your pending exchanges will appear here!'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.pending_outlined), findsOneWidget);

    type = 'Rejected';
    await tester.pumpWidget(MaterialApp(home: Exchanges(type: type)));

    expect(find.text('All your rejected exchanges will appear here!'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.cancel_outlined), findsOneWidget);

  });

}