import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookSelection.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/utils/bookGeneralInfoListView.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/searchBookForm.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Search and select book during insertion phase', (WidgetTester tester) async {

    AddBookSelection addBookSelectionWidget = AddBookSelection(setSelected: null, selectedBook: null, showDots: false, appBarHeight: 50,
      showGeneralInfo: false);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: addBookSelectionWidget)));

    expect(find.byType(SearchBookForm), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    final AddBookSelectionState addBookSelectionState = tester.state(find.byType(AddBookSelection));
    assert (addBookSelectionState.bookTitle == '');
    assert (addBookSelectionState.bookAuthor == '');

    expect(find.descendant(of: find.byType(SearchBookForm), matching: find.byWidgetPredicate((widget) => widget is TextFormField)), findsNWidgets(2));

    await tester.enterText(find.descendant(of: find.byType(SearchBookForm), matching: find.byWidgetPredicate((widget) => widget is TextFormField && widget.key == ValueKey('title'))), 'The game');
    await tester.enterText(find.descendant(of: find.byType(SearchBookForm), matching: find.byWidgetPredicate((widget) => widget is TextFormField && widget.key == ValueKey('author'))), 'Baricco');
    assert (addBookSelectionState.searchButtonPressed == false);
    assert (addBookSelectionState.bookTitle == 'The game');
    assert (addBookSelectionState.bookAuthor == 'Baricco');

  });



  testWidgets('Visualize book during insertion phase', (WidgetTester tester) async {
    dynamic selectedBook = _initializeBookGeneralInfo();

    AddBookSelection addBookSelectionWidget = AddBookSelection(setSelected: null, selectedBook: selectedBook, showDots: true, appBarHeight: 50,
        showGeneralInfo: true);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: addBookSelectionWidget)));

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: addBookSelectionWidget)));

    expect(find.byType(SearchBookForm), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);

    expect(find.byType(BookGeneralInfoListView), findsOneWidget);
    expect(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == 'The Game')), findsOneWidget);                 // title
    expect(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == 'by [Alessandro Baricco]')), findsOneWidget);  // author
    expect(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == '9788858429778')), findsOneWidget);            // ISBN
    expect(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == '336')), findsOneWidget);                      // Page count
    expect(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == '3.0')), findsOneWidget);                      // Average rating
    expect(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == '1')), findsOneWidget);                        // Ratings count

    await tester.drag(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == '1')), const Offset(0.0, -300));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.descendant(of: find.byType(BookGeneralInfoListView), matching: find.byWidgetPredicate((widget) => widget is Text && widget.data == 'IT')), findsOneWidget);                       // Language

  });

}


BookGeneralInfo _initializeBookGeneralInfo() {
  dynamic selectedBook = {'id': 'PLtsDwAAQBAJ', 'volumeInfo': {'title': 'The Game', 'authors': ['Alessandro Baricco'], 'publisher': 'Giulio Einaudi Editore', 'publishedDate': '2018-10-02',
    'description': 'Quella che stiamo vivendo non è solo una rivoluzione tecnologica fatta di nuovi oggetti, ma il risultato di un\'insurrezione mentale.', 'industryIdentifiers': [{'type': 'ISBN_13', 'identifier': '9788858429778'}, {'type': 'ISBN_10', 'identifier': '885842977X'}], 'pageCount': 336,
    'averageRating': 3, 'ratingsCount': 1, 'language': 'IT'}};

  var imageLink = selectedBook['volumeInfo']['imageLinks'] != null ? (
      selectedBook['volumeInfo']['imageLinks']['thumbnail'] != null ?
      selectedBook['volumeInfo']['imageLinks']['thumbnail'] : null
  ) : null;

  var categories = selectedBook['volumeInfo']['categories'] != null ?
  List<String>.from(selectedBook['volumeInfo']['categories'])
      : null;
  //print(categories.runtimeType);
  //print(categories);

  var averageRating = selectedBook['volumeInfo']['averageRating'] != null ?
  Utils.computeAverageRatingFromAPI(selectedBook['volumeInfo']['averageRating'].toDouble()) :
  null;

  BookGeneralInfo book = BookGeneralInfo(
    selectedBook['id'],
    selectedBook['volumeInfo']['title'],
    selectedBook['volumeInfo']['authors'].toString(),
    selectedBook['volumeInfo']['publisher'] ?? null,
    selectedBook['volumeInfo']['publishedDate'] ?? null,
    '9788858429778',
    imageLink,
    selectedBook['volumeInfo']['description'] ?? null,
    categories,
    selectedBook['volumeInfo']['language'] ?? null,
    selectedBook['volumeInfo']['pageCount'] ?? null,
    averageRating,
    selectedBook['volumeInfo']['ratingsCount'] ?? null,
  );

  return book;
}
