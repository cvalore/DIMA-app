import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/buyBooks.dart';
import 'package:flutter_firebase_auth/screens/myBooks/bookHomePageView.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooksBookList.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  //region Self
  testWidgets("MyBooksBookList Self Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();
    StreamController<BookPerGenreUserMap> _streamControllerBookPerGenreUserMap = StreamController<BookPerGenreUserMap>();
    final _providerKeyBookPerGenreUserMap = GlobalKey();

    dynamic book1 = {
      "title" : "title",
      "author" : "author",
      "price" : 9.99,
      "exchangeStatus" : "",
      "exchangeable" : false,
      "likedBy" : [],
      "insertionNumber" : 1,
      "imagesUrl" : [],
      "status" : 3,
    };
    dynamic books =
    {
      0 : book1
    };

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: StreamProvider(
        key: _providerKeyBookPerGenreUserMap,
        create: (BuildContext c) {
          return _streamControllerBookPerGenreUserMap.stream;
        },
        child: MyBooksBookList(key: _childKey, books: books, self: true, userUid: "",),
      ),
    ),),));

    expect(find.byType(BookHomePageView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is GridView && widget.semanticChildCount == 1), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(2*books.length));
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byType(Positioned), findsNothing);

    expect(find.byType(ViewBookPage), findsNothing);
    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewBookPage), findsOneWidget);

    _streamControllerBookPerGenreUserMap.close();
    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

  });
  //endregion

  //region !Self
  testWidgets("MyBooksBookList NotSelf Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();
    StreamController<BookPerGenreUserMap> _streamControllerBookPerGenreUserMap = StreamController<BookPerGenreUserMap>();
    final _providerKeyBookPerGenreUserMap = GlobalKey();

    dynamic book1 = {
      "title" : "title",
      "author" : "author",
      "price" : 9.99,
      "exchangeStatus" : "",
      "exchangeable" : false,
      "likedBy" : [],
      "insertionNumber" : 1,
      "imagesUrl" : [],
      "status" : 3,
    };
    dynamic books =
    {
      0 : book1
    };

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: StreamProvider(
        key: _providerKeyBookPerGenreUserMap,
        create: (BuildContext c) {
          return _streamControllerBookPerGenreUserMap.stream;
        },
        child: MyBooksBookList(key: _childKey, books: books, self: false, userUid: "",),
      ),
    ),),));

    expect(find.byType(BookHomePageView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is GridView && widget.semanticChildCount == 1), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "select items to buy"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "go ahead buying selected items"), findsNothing);
    expect(find.byType(Positioned), findsNothing);

    MyBooksBookListState myBooksBookListState = tester.state(find.byType(MyBooksBookList));
    assert (myBooksBookListState.selectionModeOn == false);
    await tester.tap(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "select items to buy"));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (myBooksBookListState.selectionModeOn == true);
    expect(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "select items to buy"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "go ahead buying selected items"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "deselect items to buy"), findsOneWidget);
    expect(find.byType(Positioned), findsNWidgets(2));


    assert (myBooksBookListState.selectedBooks[0] == false);
    await tester.tap(find.byType(InkWell).at(1));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (myBooksBookListState.selectedBooks[0] == true);

    expect(find.byType(BuyBooks), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "go ahead buying selected items"));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(BuyBooks), findsOneWidget);


    _streamControllerBookPerGenreUserMap.close();
    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

}