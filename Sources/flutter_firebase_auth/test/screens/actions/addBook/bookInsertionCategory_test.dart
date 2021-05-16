import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add category when inserting book', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author');
    int length = BookGenres().allBookGenres.length;

    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      CategoryBox.routeName: (context) => CategoryBox()
    };

    Category categoryWidget = Category(insertedBook: insertedBook, height: 60, justView: false);

    await tester.pumpWidget(MaterialApp(routes: routes, home:Scaffold(body: categoryWidget)));

    expect(find.byType(Container), findsNWidgets(3));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    await tester.tap(find.byType(InkWell));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == 'Epic'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == 'Epic'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Container), findsNWidgets(2));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));

    WidgetPredicate categoryPredicate = (Widget widget) =>
    widget is Text && widget.data == 'Epic';

    expect(find.byWidgetPredicate(categoryPredicate), findsOneWidget);

  });

}
