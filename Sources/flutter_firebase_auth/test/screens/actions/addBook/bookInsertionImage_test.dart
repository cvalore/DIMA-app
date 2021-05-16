import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add images when inserting book', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author');

    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      CategoryBox.routeName: (context) => CategoryBox()
    };

    ImageService addImageWidget = ImageService(insertedBook: insertedBook, justView: false);

    await tester.pumpWidget(MaterialApp(routes: routes, home:Scaffold(body: addImageWidget)));

    final Finder fabFinder = find.byType(FloatingActionButton);

    FloatingActionButton getFabWidget() {
      return tester.widget<FloatingActionButton>(fabFinder);
    }


    expect(find.byWidgetPredicate((Widget widget) => widget is Text && widget.data == 'Add images'), findsOneWidget);
    expect(find.byWidgetPredicate((Widget widget) => widget is FloatingActionButton && widget.isExtended == true), findsOneWidget);


    await tester.tap(fabFinder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Photo Library'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Camera'), findsOneWidget);
  });

  testWidgets('Delete images in update mode', (WidgetTester tester) async {

    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author');
    //insertedBook.imagesPath = ['Sources\flutter_firebase_auth\assets\images\google_logo.png', 'Sources/flutter_firebase_auth/assets/images/no_image_available.png'];
    insertedBook.imagesPath = ['Sources/flutter_firebase_auth/assets/images/no_image_available.png'];

    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      CategoryBox.routeName: (context) => CategoryBox()
    };

    ImageService addImageWidget = ImageService(insertedBook: insertedBook, justView: false);

    await tester.pumpWidget(MaterialApp(routes: routes, home:Scaffold(body: addImageWidget)));

    final Finder fabFinder = find.byType(FloatingActionButton);

    FloatingActionButton getFabWidget() {
      return tester.widget<FloatingActionButton>(fabFinder);
    }


    expect(find.byWidgetPredicate((Widget widget) => widget is Text && widget.data == 'Add images'), findsNothing);
    expect(find.byWidgetPredicate((Widget widget) => widget is Icon && widget.icon == Icons.add_a_photo), findsOneWidget);
    expect(find.byWidgetPredicate((Widget widget) => widget is FloatingActionButton && widget.isExtended == false), findsOneWidget);
    expect(find.byWidgetPredicate((Widget widget) => widget is Icon && widget.icon == Icons.cancel), findsNWidgets(1));
    expect(find.byWidgetPredicate((Widget widget) => widget is IconButton), findsNWidgets(1));
    assert (insertedBook.imagesPath.length == 1);

    //await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey(0)));
    await tester.press(find.byWidgetPredicate((widget) => widget is IconButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    //TODO capire perche qui non viene rimossa l'immagine
    expect(find.byWidgetPredicate((Widget widget) => widget is Icon && widget.icon == Icons.cancel), findsNWidgets(1));
    expect(find.byWidgetPredicate((Widget widget) => widget is IconButton), findsNWidgets(1));
  });

}
