import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPage.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionTab.dart';
import 'package:flutter_firebase_auth/screens/forum/forumMainPage.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPage.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPageFloatingButton.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

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
    for (int i = 0; i < forumDiscussionCategories.length; i++) {
      expect(find.byWidgetPredicate((widget) =>
      widget is Container && widget.key ==
          ValueKey("SelectedDropdownItem" + forumDiscussionCategories[i])),
          findsOneWidget);
    }


    final NewDiscussionPageState newDiscussionPageState = tester.state(find.byType(NewDiscussionPage));
    assert (newDiscussionPageState.title == "");
    await tester.enterText(find.byType(TextFormField), 'new message');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    assert (newDiscussionPageState.title == 'new message');

    for(int i = 0; i < forumDiscussionCategories.length - 1; i++) {
      assert (newDiscussionPageState.dropdownValue == i);
      assert (newDiscussionPageState.dropdownLabel ==
          forumDiscussionCategories[i]);

      await tester.tap(find.byWidgetPredicate((widget) =>
      widget is Container && widget.key ==
          ValueKey("SelectedDropdownItem" + forumDiscussionCategories[i])));
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      await tester.tap(find.byWidgetPredicate((widget) =>
      widget is Container && widget.key ==
          ValueKey("DropdownItem" + forumDiscussionCategories[i+1])));
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
    }

    assert (newDiscussionPageState.dropdownValue == forumDiscussionCategories.length-1);
    assert (newDiscussionPageState.dropdownLabel ==
        forumDiscussionCategories[forumDiscussionCategories.length-1]);


    await tester.tap(find.byType(NewDiscussionPageFloatingButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(DiscussionPage), findsNothing);

  });
}