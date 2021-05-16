import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homeBody.dart';
import 'package:flutter_firebase_auth/screens/home/homeBookInfo.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("HomeBody Test", (WidgetTester tester) async {

    tester.binding.window.physicalSizeTestValue = Size(500, 800); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    StreamController<BookPerGenreMap> _streamController = StreamController<BookPerGenreMap>();
    final _providerKey1 = GlobalKey();
    final _childKey1 = GlobalKey();
    StreamController<BookPerGenreUserMap> _streamController2 = StreamController<BookPerGenreUserMap>();
    final _providerKey2 = GlobalKey();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKey1,
      create: (BuildContext c) {
        return _streamController.stream;
      },
      child: StreamProvider(
        key: _providerKey2,
        create: (BuildContext c) {
          return _streamController2.stream;
        },
        child: HomeBody(key: _childKey1,)
      ),
    ),),));
    expect(Provider.of<BookPerGenreMap>(_childKey1.currentContext, listen: false), isNull);
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(MyBooks), findsNothing);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(CustomScrollView), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No books yet, the books for sale will appear here"), findsOneWidget);

    dynamic booksFantasy = {
      "books" : [
        {
          "key1" : {
            "title": "",
            "author": "",
            "thumbnail": "",
          }
        },
        {
          "key2" : {
            "title": "",
            "author": "",
            "thumbnail": "",
          }
        }
      ]
    };
    dynamic books = {
      "Fantasy" : booksFantasy,
    };
    _streamController.add(BookPerGenreMap(books));


    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKey1,
      create: (BuildContext c) {
        return _streamController.stream;
      },
      child: StreamProvider(
          key: _providerKey2,
          create: (BuildContext c) {
            return _streamController2.stream;
          },
          child: HomeBody(key: _childKey1,)
      ),
    ),),));
    expect(Provider.of<BookPerGenreMap>(_childKey1.currentContext, listen: false), isNotNull);
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(MyBooks), findsNothing);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No books yet, the books for sale will appear here"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is ListView && widget.semanticChildCount == booksFantasy['books'].length), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);


    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("prova")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(MyBooks), findsOneWidget);

    _streamController.close();
    _streamController2.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}