import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';
import 'package:flutter_firebase_auth/screens/notifications/viewBookFromTransaction.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("ViewBookFromTransaction Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue =
        Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<
        AuthCustomUser> _streamControllerAuthUser = StreamController<
        AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();


    BookGeneralInfo bookGeneralInfo = BookGeneralInfo(
        "id",
        "title",
        "author",
        "publisher",
        "",
        "isbn13",
        "",
        "description",
        [],
        "language",
        100,
        4,
        50
    );
    InsertedBook book = InsertedBook(
        title: "bookTitle",
        author: "bookAuthor",
        id: "id",
        isbn13: "isbn13",
        status: 3,
        category: "Fantasy",
        imagesPath: [],
        imagesUrl: [],
        insertionNumber: 1,
        likedBy: [],
        comment: "comment",
        price: 9.99,
        exchangeable: false,
        exchangeStatus: "available",
        bookGeneralInfo: bookGeneralInfo
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: Builder(builder: (BuildContext context) {
        return ViewBookFromTransaction(key: _childKey, book: book);
      },),
    ),),));

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(ImageService), findsOneWidget);
    expect(find.byType(Status), findsOneWidget);
    expect(find.byType(Price), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == book.title), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == book.author.substring(1, book.author.length - 1)), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == book.category), findsOneWidget);


    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}