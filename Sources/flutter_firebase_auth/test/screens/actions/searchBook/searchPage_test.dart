import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookPage.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchPage.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchUserPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  //region Portrait
  testWidgets("SearchPage Portrait Test", (WidgetTester tester) async {
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
      child: SearchPage(key: _childKey, books: [],),
    ),),));

    expect(find.byType(MyVerticalTabs), findsNothing);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.byType(SearchBookPage), findsOneWidget);
    expect(find.byType(SearchUserPage), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Users"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Books"), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Users"));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(SearchBookPage), findsNothing);
    expect(find.byType(SearchUserPage), findsOneWidget);


    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

  //region Landscape
  testWidgets("SearchPage Landscape Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1600, 1500); //set dim to be portrait and not landscape

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
      child: SearchPage(key: _childKey, books: [],),
    ),),));

    expect(find.byType(MyVerticalTabs), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
    expect(find.byType(TabBarView), findsNothing);
    expect(find.byType(SearchBookPage), findsOneWidget);
    expect(find.byType(SearchUserPage), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Users"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Books"), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Users"));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(SearchBookPage), findsNothing);
    expect(find.byType(SearchUserPage), findsOneWidget);


    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

}