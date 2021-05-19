import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationPage.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationProfile.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  //region New
  testWidgets("NotificationProfile New Test", (WidgetTester tester) async {
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
      child: Builder(builder: (BuildContext context) {
        return NotificationProfile(key: _childKey, height: 60, transactions: transactions, oldContext: context, lastNotificationDate: Timestamp.now(),);
      },),
    ),),));

    NotificationProfile notificationProfile = tester.widget(find.byType(NotificationProfile));
    assert (notificationProfile.newNotifications == true);

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.notifications_none_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Notifications"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.arrow_forward_ios), findsOneWidget);

    expect(find.byType(InkWell), findsOneWidget);
    expect(find.byType(NotificationPage), findsNothing);
    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(NotificationPage), findsOneWidget);

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

  //region Old
  testWidgets("NotificationProfile Old Test", (WidgetTester tester) async {
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
        "time" : Timestamp.fromDate(DateTime.now().subtract(Duration(minutes: 1))),
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
      child: Builder(builder: (BuildContext context) {
        return NotificationProfile(key: _childKey, height: 60, transactions: transactions, oldContext: context, lastNotificationDate: Timestamp.now(),);
      },),
    ),),));

    NotificationProfile notificationProfile = tester.widget(find.byType(NotificationProfile));
    assert (notificationProfile.newNotifications == false);

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.notifications_none_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Notifications"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.arrow_forward_ios), findsOneWidget);

    expect(find.byType(InkWell), findsOneWidget);
    expect(find.byType(NotificationPage), findsNothing);
    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(NotificationPage), findsOneWidget);

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

}