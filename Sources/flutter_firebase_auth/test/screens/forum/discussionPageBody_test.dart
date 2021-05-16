import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPageBody.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("DiscussionPageBody Test", (WidgetTester tester) async {
    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    StreamController<ForumDiscussion> _streamController = StreamController<ForumDiscussion>();
    final _providerKey = GlobalKey();
    final _childKey = GlobalKey();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
      StreamProvider(
        key: _providerKey,
        create: (BuildContext c) {
          return _streamController.stream;
        },
        child: DiscussionPageBody(key: _childKey, db: Utils.databaseService, user: Utils.mySelf,)),
    ),));
    expect(Provider.of<ForumDiscussion>(_childKey.currentContext, listen: false), isNull);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);

    ForumDiscussion forumDiscussion = ForumDiscussion("", "", List<Message>(), DateTime.now(), "");
    _streamController.add(forumDiscussion);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
    StreamProvider(
        key: _providerKey,
        create: (BuildContext c) {
          return _streamController.stream;
        },
        child: DiscussionPageBody(key: _childKey, db: Utils.databaseService, user: Utils.mySelf,)),
    ),));
    expect(Provider.of<ForumDiscussion>(_childKey.currentContext, listen: false), isNotNull);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);


    Message messageAnon = Message("","",DateTime.now(), "message body");
    Message message = Message("uidSender","",DateTime.now(), "message body");
    forumDiscussion.messages.add(messageAnon);
    forumDiscussion.messages.add(messageAnon);
    forumDiscussion.messages.add(message);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
    StreamProvider(
        key: _providerKey,
        create: (BuildContext c) {
          return _streamController.stream;
        },
        child: DiscussionPageBody(key: _childKey, db: Utils.databaseService, user: Utils.mySelf,)),
    ),));
    expect(Provider.of<ForumDiscussion>(_childKey.currentContext, listen: false), isNotNull);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No messages yet"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is ListView && widget.semanticChildCount == 3), findsOneWidget);
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "ANONYMOUS:"), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "ANONYMOUS:"+message.uidSender), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == message.messageBody), findsNWidgets(3));

    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
    StreamProvider(
        key: _providerKey,
        create: (BuildContext c) {
          return _streamController.stream;
        },
        child: DiscussionPageBody(key: _childKey, db: Utils.databaseService, user: Utils.mySelf,)),
    ),));
    final DiscussionPageBodyState discussionPageBodyState = tester.state(find.byType(DiscussionPageBody));

    assert (discussionPageBodyState.message == "");
    await tester.enterText(find.byType(TextFormField), 'new message');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    assert (discussionPageBodyState.message == 'new message');

    await tester.tap(find.byType(MaterialButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    assert (discussionPageBodyState.message == '');

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(VisualizeProfileMainPage), findsNothing);

    await tester.tap(find.byType(InkWell).at(2));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(VisualizeProfileMainPage), findsOneWidget);

    _streamController.close();
  });
}