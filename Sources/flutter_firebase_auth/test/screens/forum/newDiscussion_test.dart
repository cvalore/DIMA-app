import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPage.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPageBody.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionTab.dart';
import 'package:flutter_firebase_auth/screens/forum/forumMainPage.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPage.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPageFloatingButton.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets("NewDiscussion Test", (WidgetTester tester) async {
    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    await tester.pumpWidget(MaterialApp(home: ForumMainPage(updateDiscussionView: (){},)));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(DiscussionTab), findsOneWidget);
    expect(find.byType(NewDiscussionPage), findsNothing);
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.byType(Form), findsNothing);
    expect(find.byType(TextFormField), findsNothing);
    expect(find.byType(NewDiscussionPageFloatingButton), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(NewDiscussionPage), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(NewDiscussionPageFloatingButton), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget.key == ValueKey("NewDiscussionDropdownButtonKey")), findsOneWidget);

    final NewDiscussionPageState newDiscussionPageState = tester.state(find.byType(NewDiscussionPage));
    assert (newDiscussionPageState.title == "");
    await tester.enterText(find.byType(TextFormField), 'new message');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    assert (newDiscussionPageState.title == 'new message');

    await tester.tap(find.byType(NewDiscussionPageFloatingButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(DiscussionPage), findsNothing);

  });
}