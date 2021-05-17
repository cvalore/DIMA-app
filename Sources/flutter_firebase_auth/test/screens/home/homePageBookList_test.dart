import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homeBookInfo.dart';
import 'package:flutter_firebase_auth/screens/home/homePageBookList.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("HomePageBookList Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(530, 1000); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();

    dynamic books = [
      {
        "id" : {
          "title" : "title",
          "author" : "author",
          "thumbnail" : "",
        }
      }
    ];
    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
      StreamProvider(
          key: _providerKeyAuthUser,
          create: (BuildContext c) {
            return _streamControllerAuthUser.stream;
          },
          child: HomePageBookList(key: _childKey, genre: "Fantasy", books: books,)
      )
    )));
    expect(find.byWidgetPredicate((widget) => widget is ListView && widget.semanticChildCount == 1), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is InkWell && widget.key == ValueKey("PushBookPageInkWell")), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "title"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "author"), findsOneWidget);

    expect(find.byType(HomeBookInfo), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is InkWell && widget.key == ValueKey("PushBookPageInkWell")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(HomeBookInfo), findsOneWidget);

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}