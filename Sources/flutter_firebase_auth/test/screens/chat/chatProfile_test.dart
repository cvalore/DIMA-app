import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/chat/chatProfile.dart';
import 'package:flutter_firebase_auth/screens/profile/chat/chatProfileBody.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Chat Profile Test", (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    dynamic chatsMap;
    Timestamp lastChatsDate;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ChatProfile(height: 60, chatsMap: chatsMap, lastChatsDate: lastChatsDate,),),));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsNWidgets(1));

    lastChatsDate = Timestamp.fromDate(DateTime.now());
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ChatProfile(height: 60, chatsMap: chatsMap, lastChatsDate: lastChatsDate,),),));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsNWidgets(0));

    chatsMap = [{
      "chatKey" : "",
      "userUid1" : "",
      "userUid2" : "",
      "userUid1Username" : "",
      "userUid2Username" : "",
      "messages" : [],
      "time" : Timestamp.fromDate(DateTime.now().add(Duration(minutes: 1))),
    }];
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ChatProfile(height: 60, chatsMap: chatsMap, lastChatsDate: lastChatsDate,),),));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsNWidgets(1));

    expect(find.byType(ChatProfileBody), findsNWidgets(0));
    await tester.tap(find.byWidgetPredicate((widget) => widget is InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(ChatProfileBody), findsNWidgets(1));
  });
}