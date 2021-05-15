import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/pendingPageBody.dart';
import 'package:flutter_firebase_auth/screens/chat/viewPendingBook.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("PendingPageBody test", (WidgetTester tester) async {
    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    List<dynamic> transactions = [];

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: PendingPageBody(db: Utils.databaseService, user: Utils.mySelf, transactions: transactions,),),));
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(BottomTwoDots), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No transaction to approve yet"), findsOneWidget);


    dynamic offeredBook = {
      "id" : "offeredBookId",
      "title" : "offeredBookTitle",
      "author" : "offeredBookAuthor",
      "insertionNumber" : 1,
    };
    dynamic receivedBook = {
      "id" : "receivedBookId",
      "title" : "receivedBookTitle",
      "author" : "receivedBookAuthor",
      "insertionNumber" : 2,
    };
    dynamic exch = [
      {
        "exchangeStatus" : "pending",
        "offeredBook" : offeredBook,
        "receivedBook" : receivedBook,
      },
      {
        "exchangeStatus" : "complete",
      },
      {
        "exchangeStatus" : "pending",
        "offeredBook" : offeredBook,
        "receivedBook" : receivedBook,
      }
    ];
    dynamic tr = {
      "buyer" : "buyerUid",
      "seller" : "sellerUid",
      "exchanges" : exch,
    };
    transactions.add(tr);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: PendingPageBody(db: Utils.databaseService, user: Utils.mySelf, transactions: transactions,),),));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is ListView && widget.semanticChildCount == 1), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No transaction to approve yet"), findsNothing);
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byType(InkWell), findsNWidgets(8));
    expect(find.byType(ViewPendingBook), findsNothing);
    expect(find.byType(BottomTwoDots), findsOneWidget);


    await tester.tap(find.byType(InkWell).at(0));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewPendingBook), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewPendingBook), findsNothing);

    await tester.tap(find.byType(InkWell).at(1));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewPendingBook), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewPendingBook), findsNothing);

  });
}