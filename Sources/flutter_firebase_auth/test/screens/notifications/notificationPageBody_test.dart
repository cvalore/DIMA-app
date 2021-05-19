import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationPageBody.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationText.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets("NotificationPageBody Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: NotificationPageBody(transactions: null, lastNotificationDate: null),
    ),),));

    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No notifications yet"), findsOneWidget);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    dynamic transactions = [
      {
        "id" : "id1",
        "time" : Timestamp.fromDate(DateTime.now().add(Duration(minutes: 1))),
        "buyerUsername" : "buyerUsername1",
        "buyer" : "buyerUid1",
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
        }],
        "exchanges" : [
          {
            "receivedBook" : {
              "title" : "titleReceived1",
              "author" : "authorReceived1",
              "price" : 20.99,
            },
            "offeredBook" : {
              "title" : "titleOffered1",
              "author" : "authorOffered1",
              "price" : 21.99,
            }
          },
        ],
      },
      {
        "id" : "id2",
        "time" : Timestamp.fromDate(DateTime.now().add(Duration(minutes: 2))),
        "buyer" : "buyerUid2",
        "buyerUsername" : "buyerUsername2",
        "sellerUsername" : "sellerUsername2",
        "chosenShippingMode" : "chosenShippingMode2",
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
        }],
        "exchanges" : [
          {
            "receivedBook" : {
              "title" : "titleReceived2",
              "author" : "authorReceived2",
              "price" : 30.99,
            },
            "offeredBook" : {
              "title" : "titleOffered2",
              "author" : "authorOffered2",
              "price" : 31.99,
            }
          },
        ],
      },
    ];
    DateTime lastNotificationDate = DateTime.now();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: NotificationPageBody(key: _childKey, transactions: transactions, lastNotificationDate: Timestamp.fromDate(lastNotificationDate)),
    ),),));

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(NotificationText), findsNWidgets(transactions.length));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No notifications yet"), findsNothing);

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}