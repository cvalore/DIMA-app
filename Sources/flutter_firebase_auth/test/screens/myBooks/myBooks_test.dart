import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooksBookList.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  testWidgets("MyBooks Test", (WidgetTester tester) async {
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
        child: MyBooks(key: _childKey, books: null, self: true, userUid: "",),
      ),
    ),),));

    expect(find.byType(MyBooksBookList), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No books yet, the books you add will appear here"), findsOneWidget);

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
        child: MyBooks(key: _childKey, books: books, self: true, userUid: "",),
      ),
    ),),));

    expect(find.byType(MyBooksBookList), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No books yet, the books you add will appear here"), findsNothing);

    _streamControllerBookPerGenreUserMap.close();
    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

  });

}