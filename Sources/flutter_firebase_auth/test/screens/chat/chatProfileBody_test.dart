import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPage.dart';
import 'package:flutter_firebase_auth/screens/profile/chat/chatProfileBody.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("Chat Profile Test", (WidgetTester tester) async {
    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();


    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ChatProfileBody(chats: List<Chat>(), lastChatsDate: null,),),));
    expect(find.byType(SingleChildScrollView), findsNWidgets(0));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No chats yet"), findsNWidgets(1));

    List<Message> messages1 = List<Message>();
    List<Message> messages2 = List<Message>();
    List<Chat> chats = List<Chat>();
    chats.add(Chat("", "", "", "", messages1, DateTime.now()));
    chats.add(Chat("", "", "", "", messages2, DateTime.now()));
    chats.forEach((element) { element.setShowNew(false); });

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ChatProfileBody(chats: chats, lastChatsDate: null,),),));
    expect(find.byType(SingleChildScrollView), findsNWidgets(1));
    expect(find.byType(InkWell), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No chats yet"), findsNWidgets(0));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsNWidgets(0));

    messages1.add(Message("", "", DateTime.now().add(Duration(minutes: 1)), ""));
    chats = List<Chat>();
    chats.add(Chat("", "", "", "", messages1, DateTime.now()));
    chats.add(Chat("", "", "", "", messages2, DateTime.now()));
    chats[0].showNew = true;
    chats[1].showNew = false;

    StreamController<AuthCustomUser> _authStreamController = StreamController<AuthCustomUser>();
    final _providerKey = GlobalKey();
    final _childKey = GlobalKey();



    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKey,
      create: (BuildContext c) {
        return _authStreamController.stream;
      },
      child: ChatProfileBody(key: _childKey, chats: chats, lastChatsDate: Timestamp.now(),)
    ),),));

    expect(Provider.of<AuthCustomUser>(_childKey.currentContext, listen: false), isNull);
    _authStreamController.add(AuthCustomUser("", "", false));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(Provider.of<AuthCustomUser>(_childKey.currentContext, listen: false), isNotNull);

    expect(find.byType(SingleChildScrollView), findsNWidgets(1));
    expect(find.byType(InkWell), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No chats yet"), findsNWidgets(0));
    expect(find.byType(ChatPage), findsNWidgets(0));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.fiber_new), findsNWidgets(1));

    await tester.tap(find.byWidgetPredicate((widget) => widget is InkWell && widget.child.runtimeType == Stack).at(0));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(ChatPage), findsNWidgets(1));

    await tester.pageBack();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
        key: _providerKey,
        create: (BuildContext c) {
          return _authStreamController.stream;
        },
        child: ChatProfileBody(key: _childKey, chats: chats, lastChatsDate: Timestamp.now(),)
    ),),));

    expect(Provider.of<AuthCustomUser>(_childKey.currentContext, listen: false), isNotNull);
    await tester.tap(find.byType(InkWell).at(1));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(VisualizeProfileMainPage), findsNWidgets(1));


    _authStreamController.close();
  });
}