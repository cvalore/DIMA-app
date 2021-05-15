import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPage.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionTabBody.dart';
import 'package:flutter_firebase_auth/screens/profile/chat/chatProfile.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("DiscussionTabBody Test", (WidgetTester tester) async {
    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
      DiscussionTabBody(discussions: null, updateDiscussionView: () {},),
    ),));
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No discussions yet"), findsOneWidget);
    expect(find.byType(DiscussionPage), findsNothing);

    dynamic disc1 = {
      "category" : "Other",
      "startedBy" : "",
      "startedByProfilePicture" : "",
      "startedByUsername" : "",
      "time" : Timestamp.fromDate(DateTime.now()),
      'title' : "",
      "messages" : [],
    };
    dynamic disc2 = {
      "category" : "Shipping",
      "startedBy" : "startedByUid",
      "startedByProfilePicture" : "",
      "startedByUsername" : "",
      "time" : Timestamp.fromDate(DateTime.now()),
      'title' : "",
      "messages" : [],
    };
    dynamic disc3 = {
      "category" : "Book",
      "startedBy" : "startedByUid",
      "startedByProfilePicture" : "",
      "startedByUsername" : "",
      "time" : Timestamp.fromDate(DateTime.now()),
      'title' : "",
      "messages" : [],
    };
    dynamic disc4 = {
      "category" : "Promotion",
      "startedBy" : "startedByUid",
      "startedByProfilePicture" : "",
      "startedByUsername" : "",
      "time" : Timestamp.fromDate(DateTime.now()),
      'title' : "",
      "messages" : [],
    };
    dynamic discussions = [
      disc1,
      disc2,
      disc3,
      disc4
    ];

    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
      DiscussionTabBody(discussions: discussions, updateDiscussionView: () {},),
    ),));

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No discussions yet"), findsNothing);
    expect(find.byType(ManuallyCloseableExpansionTile), findsNWidgets(forumDiscussionCategories.length));
    expect(find.byType(InkWell), findsNWidgets(discussions.length));
    //expect(find.byType(CircleAvatar), findsNWidgets(discussions.length));

    await tester.tap(find.byType(InkWell).at(0));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    //expect(find.byType(DiscussionPage), findsOneWidget);

  });
}