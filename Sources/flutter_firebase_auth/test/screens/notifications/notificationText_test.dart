import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationText.dart';
import 'package:flutter_firebase_auth/screens/notifications/viewBookFromTransaction.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets("NotificationText Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();

    dynamic transactions = [
      {
        "id" : "id1",
        "time" : Timestamp.fromDate(DateTime.now().add(Duration(minutes: 1))),
        "buyer" : "buyerUid1",
        "buyerUsername" : "buyerUsername1",
        "sellerUsername" : "sellerUsername1",
        "chosenShippingMode" : "chosenShippingMode1",
        "shippingAddress" : {
          "fullName" : "fullName1",
          "city" : "city1",
          "state" : "state1",
          "address 1" : "address 11",
          "address 2" : "address 21",
          "CAP" : "CAP1",
        },
        "paidBooks" : [{
          "title" : "titlePaid1",
          "author" : "authorPaid1",
          "price" : 19.99,
          "category" : "Fantasy",
          "status" : 3,
        }],
        "exchanges" : [
          {
            "receivedBook" : {
              "title" : "titleReceived1",
              "author" : "authorReceived1",
              "price" : 20.99,
              "category" : "Fantasy",
              "status" : 3,
            },
            "offeredBook" : {
              "title" : "titleOffered1",
              "author" : "authorOffered1",
              "price" : 21.99,
              "category" : "Fantasy",
              "status" : 3,
            }
          },
        ],
      },
      {
        "id" : "id2",
        "time" : Timestamp.fromDate(DateTime.now().subtract(Duration(minutes: 2))),
        "buyer" : "buyerUid2",
        "buyerUsername" : "buyerUsername2",
        "sellerUsername" : "sellerUsername2",
        "chosenShippingMode" : "express courier",
        "shippingAddress" : {
          "fullName" : "fullName2",
          "city" : "city2",
          "state" : "state2",
          "address 1" : "address 12",
          "address 2" : "address 22",
          "CAP" : "CAP2",
        },
        "paidBooks" : [{
          "title" : "titlePaid2",
          "author" : "authorPaid2",
          "price" : 29.99,
          "category" : "Fantasy",
          "status" : 3,
        }],
        "exchanges" : [
          {
            "receivedBook" : {
              "title" : "titleReceived2",
              "author" : "authorReceived2",
              "price" : 30.99,
              "category" : "Fantasy",
              "status" : 3,
            },
            "offeredBook" : {
              "title" : "titleOffered2",
              "author" : "authorOffered2",
              "price" : 31.99,
              "category" : "Fantasy",
              "status" : 3,
            }
          },
        ],
      },
    ];

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: NotificationText(key: _childKey, transaction: transactions[0], lastNotificationDate: Timestamp.fromDate(DateTime.now())),
    ),),));

    expect(find.byWidgetPredicate((widget) => widget is Card && widget.color == Colors.white24), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Card && widget.color == Colors.white10), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[0]['id']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == DateTime.fromMillisecondsSinceEpoch(transactions[0]['time'].seconds * 1000).toString().split('.')[0]), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[0]['buyerUsername']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[0]['chosenShippingMode']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) =>
    widget is Text && widget.data ==
        transactions[0]['shippingAddress']['fullName'] + "\n" +
            transactions[0]['shippingAddress']['city'] + ", " +
            transactions[0]['shippingAddress']['state'] + ", " +
            transactions[0]['shippingAddress']['address 1'] + " " +
            transactions[0]['shippingAddress']['address 2'] + ", " +
            transactions[0]['shippingAddress']['CAP']), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[0]['paidBooks'][0]['title'] + " by " + transactions[0]['paidBooks'][0]['author'] + "\n(€" + transactions[0]['paidBooks'][0]['price'].toStringAsFixed(2) + ")"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == "You give: "), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == "You get: "), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[0]['exchanges'][0]['receivedBook']['title'] + " by " + transactions[0]['exchanges'][0]['receivedBook']['author']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[0]['exchanges'][0]['offeredBook']['title'] + " by " + transactions[0]['exchanges'][0]['offeredBook']['author']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsOneWidget);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: NotificationText(key: _childKey, transaction: transactions[1], lastNotificationDate: Timestamp.fromDate(DateTime.now())),
    ),),));

    expect(find.byWidgetPredicate((widget) => widget is Card && widget.color == Colors.white24), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Card && widget.color == Colors.white10), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[1]['id']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == DateTime.fromMillisecondsSinceEpoch(transactions[1]['time'].seconds * 1000).toString().split('.')[0]), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[1]['buyerUsername']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[1]['chosenShippingMode']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) =>
    widget is Text && widget.data ==
        transactions[1]['shippingAddress']['fullName'] + "\n" +
            transactions[1]['shippingAddress']['city'] + ", " +
            transactions[1]['shippingAddress']['state'] + ", " +
            transactions[1]['shippingAddress']['address 1'] + " " +
            transactions[1]['shippingAddress']['address 2'] + ", " +
            transactions[1]['shippingAddress']['CAP']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[1]['paidBooks'][0]['title'] + " by " + transactions[1]['paidBooks'][0]['author'] + "\n(€" + transactions[1]['paidBooks'][0]['price'].toStringAsFixed(2) + ")"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == "You give: "), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == "You get: "), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[1]['exchanges'][0]['receivedBook']['title'] + " by " + transactions[1]['exchanges'][0]['receivedBook']['author']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data  == transactions[1]['exchanges'][0]['offeredBook']['title'] + " by " + transactions[1]['exchanges'][0]['offeredBook']['author']), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsNothing);

    expect(find.byType(InkWell), findsNWidgets(5));

    expect(find.byType(ViewBookFromTransaction), findsNothing);
    await tester.tap(find.byType(InkWell).at(2));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewBookFromTransaction), findsOneWidget);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: NotificationText(key: _childKey, transaction: transactions[1], lastNotificationDate: Timestamp.fromDate(DateTime.now())),
    ),),));

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(ViewBookFromTransaction), findsNothing);
    await tester.tap(find.byType(InkWell).at(3));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewBookFromTransaction), findsOneWidget);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: NotificationText(key: _childKey, transaction: transactions[1], lastNotificationDate: Timestamp.fromDate(DateTime.now())),
    ),),));

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(ViewBookFromTransaction), findsNothing);
    await tester.tap(find.byType(InkWell).at(4));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewBookFromTransaction), findsOneWidget);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: NotificationText(key: _childKey, transaction: transactions[1], lastNotificationDate: Timestamp.fromDate(DateTime.now())),
    ),),));

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(VisualizeProfileMainPage), findsNothing);
    await tester.tap(find.byType(InkWell).at(1));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(VisualizeProfileMainPage), findsOneWidget);

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}