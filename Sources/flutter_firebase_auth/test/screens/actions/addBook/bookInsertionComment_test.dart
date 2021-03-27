import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/comment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add comment when inserting book', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    InsertedBook insertedBook = InsertedBook(title: 'title', author: 'author');
    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      CommentBox.routeName: (context) => CommentBox()
    };

    await tester.pumpWidget(MaterialApp(routes: routes, home:Comment(insertedBook: insertedBook, height: 60, justView: false)));

    expect(find.byType(Container), findsNWidgets(3));
    expect(find.byType(Scaffold), findsNothing);
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'my comment');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Container), findsNWidgets(2));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));

    WidgetPredicate commentTestPredicate = (Widget widget) =>
    widget is Text && widget.data == 'my comment';

    WidgetPredicate commentPredicate = (Widget widget) =>
    widget is Comment && widget.insertedBook.comment == 'my comment';

    expect(find.byWidgetPredicate(commentTestPredicate), findsOneWidget);
    expect(find.byWidgetPredicate(commentPredicate), findsOneWidget);

  });

}
