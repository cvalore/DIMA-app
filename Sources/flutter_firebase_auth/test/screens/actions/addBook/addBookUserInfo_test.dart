import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('save inserted book', (WidgetTester tester) async {

    //TODO integration test
    /*
    AddBookUserInfo addBookSelectionWidget = AddBookUserInfo(insertedBook: InsertedBook(), isInsert: true);

    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      CommentBox.routeName: (context) => CommentBox(),
      CategoryBox.routeName: (context) => CategoryBox(),
      PriceBox.routeName: (context) => PriceBox(),
    };

    await tester.pumpWidget(MaterialApp(routes: routes, home: Scaffold(body: addBookSelectionWidget)));

    //expect(find.byType(SearchBookForm), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    final AddBookSelectionState addBookSelectionState = tester.state(
        find.byType(AddBookSelection));
    assert (addBookSelectionState.bookTitle == '');
    assert (addBookSelectionState.bookAuthor == '');

    expect(find.descendant(of: find.byType(SearchBookForm),
        matching: find.byWidgetPredicate((widget) => widget is TextFormField)),
        findsNWidgets(2));

    await tester.enterText(find.descendant(of: find.byType(SearchBookForm),
        matching: find.byWidgetPredicate((widget) =>
        widget is TextFormField && widget.key == ValueKey('title'))),
        'The game');
    await tester.enterText(find.descendant(of: find.byType(SearchBookForm),
        matching: find.byWidgetPredicate((widget) =>
        widget is TextFormField && widget.key == ValueKey('author'))),
        'Baricco');
    assert (addBookSelectionState.searchButtonPressed == false);
    assert (addBookSelectionState.bookTitle == 'The game');
    assert (addBookSelectionState.bookAuthor == 'Baricco');

     */
  });


}