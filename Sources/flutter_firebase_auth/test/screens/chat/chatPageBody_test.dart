import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPageBody.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("ChatPageBody Test", (WidgetTester tester) async  {
    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    StreamController<Chat> _authStreamController1 = StreamController<Chat>();
    final _providerKey1 = GlobalKey();
    final _childKey1 = GlobalKey();


    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
        key: _providerKey1,
        create: (BuildContext c) {
          return _authStreamController1.stream;
        },
        child: ChatPageBody(key: _childKey1, db: Utils.databaseService, user: Utils.mySelf,),
    ),),));
    expect(Provider.of<Chat>(_childKey1.currentContext, listen: false), isNull);
    expect(find.byType(ListView), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsOneWidget);
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);
    expect(find.byType(BottomTwoDots), findsOneWidget);

    Chat chat = Chat("","","","",List<Message>(), DateTime.now());
    _authStreamController1.add(chat);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(Provider.of<Chat>(_childKey1.currentContext, listen: false), isNotNull);
    expect(find.byType(ListView), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsOneWidget);
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);
    expect(find.byType(BottomTwoDots), findsOneWidget);

    Message messageOther = Message("testerUidOther", "testerNameOther", DateTime.now(), "testerBodyOther");
    chat.messages.add(messageOther);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKey1,
      create: (BuildContext c) {
        return _authStreamController1.stream;
      },
      child: ChatPageBody(key: _childKey1, db: Utils.databaseService, user: Utils.mySelf,),
    ),),));
    expect(Provider.of<Chat>(_childKey1.currentContext, listen: false), isNotNull);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Card && widget.color == Colors.blueGrey[700]), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == messageOther.messageBody), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == messageOther.time.toString().split(' ')[0] + " " + messageOther.time.toString().split(' ')[1].split('.')[0].substring(0, 5),), findsOneWidget);
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);
    expect(find.byType(BottomTwoDots), findsOneWidget);

    Message messageMe = Message("", "", DateTime.now(), "testerBodyMe");
    chat.messages.add(messageMe);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKey1,
      create: (BuildContext c) {
        return _authStreamController1.stream;
      },
      child: ChatPageBody(key: _childKey1, db: Utils.databaseService, user: Utils.mySelf,),
    ),),));

    expect(Provider.of<Chat>(_childKey1.currentContext, listen: false), isNotNull);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is ListView && widget.semanticChildCount == 2), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Card && widget.color == Colors.blueGrey[700]), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Card && widget.color == Colors.blue[500]), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == messageOther.messageBody), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == messageMe.messageBody), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == messageOther.time.toString().split(' ')[0] + " " + messageOther.time.toString().split(' ')[1].split('.')[0].substring(0, 5),), findsNWidgets(2));
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);
    expect(find.byType(BottomTwoDots), findsOneWidget);


    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKey1,
      create: (BuildContext c) {
        return _authStreamController1.stream;
      },
      child: ChatPageBody(key: _childKey1, db: Utils.databaseService, user: Utils.mySelf,),
    ),),));
    final ChatPageBodyState chatPageBodyState = tester.state(find.byType(ChatPageBody));

    assert (chatPageBodyState.message == "");
    await tester.enterText(find.byType(TextFormField), 'new message');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    assert (chatPageBodyState.message == 'new message');

    await tester.tap(find.byType(MaterialButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    assert (chatPageBodyState.message == '');

    _authStreamController1.close();
  });
}

