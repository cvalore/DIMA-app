import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookInfoBody.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/searchBookForm.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:radio_grouped_buttons/custom_buttons/custom_radio_buttons_group.dart';

void main() {

  //region Modifiers
  testWidgets("SearchBookPage Modifiers Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: SearchBookPage(key: _childKey, books: [],),
    ),),));

    SearchBookPageState searchBookPageState = tester.state(find.byType(SearchBookPage));
    assert (searchBookPageState.openModifiersSection == false);
    assert (searchBookPageState.searchLoading == false);

    expect(find.byType(SearchBookInfoBody), findsNothing);
    expect(find.byType(SearchBookForm), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "searchBookBtn"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.search), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byType(ManuallyCloseableExpansionTile), findsNothing);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == searchBookPageState.resultMessage), findsOneWidget);

    assert (searchBookPageState.searchTitle == '');
    await tester.enterText(find.byType(TextFormField).first, "title");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.searchTitle == 'title');

    assert (searchBookPageState.searchAuthor == '');
    await tester.enterText(find.byType(TextFormField).last, "author");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.searchAuthor == 'author');

    await tester.tap(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.keyboard_arrow_down));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.openModifiersSection == true);
    expect(find.byType(ManuallyCloseableExpansionTile), findsNWidgets(2));

    //GlobalKey<ManuallyCloseableExpansionTileState> filterListTileState = tester.widget(find.byType(ManuallyCloseableExpansionTile).first).key;
    //GlobalKey<ManuallyCloseableExpansionTileState> orderByListTileState = tester.widget(find.byType(ManuallyCloseableExpansionTile).last).key;

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Price"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Min €"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Max €"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Photos"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Exchangeable"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Genre"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "ISBN"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Apply"), findsNothing);
    await tester.tap(find.byType(ManuallyCloseableExpansionTile).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Price"), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Min €"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Max €"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Photos"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Exchangeable"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Genre"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "ISBN"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Apply"), findsOneWidget);

    expect(find.byType(TextFormField), findsNWidgets(5));

    assert (searchBookPageState.lessThanPrice == "");
    await tester.enterText(find.byType(TextFormField).at(3), "2.99");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.lessThanPrice == "2.99");

    assert (searchBookPageState.greaterThanPrice == "");
    await tester.enterText(find.byType(TextFormField).at(2), "16.99");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.greaterThanPrice == "16.99");

    assert (searchBookPageState.isbnFilter == "");
    await tester.enterText(find.byType(TextFormField).at(4), "156");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.isbnFilter == "156");

    expect(find.byType(Checkbox), findsNWidgets(2));

    assert (searchBookPageState.photosCheckBox == false);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.photosCheckBox == true);

    assert (searchBookPageState.exchangeableCheckBox == false);
    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.exchangeableCheckBox == true);

    expect(find.byWidgetPredicate((widget) => widget.key == ValueKey("AllGenresSelectedItem")), findsOneWidget);

    assert (searchBookPageState.dropdownGenreLabel == "");
    assert (searchBookPageState.dropdownGenreValue == 0);
    await tester.tap(find.byWidgetPredicate((widget) => widget.key == ValueKey("AllGenresSelectedItem")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byWidgetPredicate((widget) => widget.key == ValueKey("FantasyItem")), findsOneWidget);
    await tester.tap(find.byWidgetPredicate((widget) => widget.key == ValueKey("FantasyItem")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.dropdownGenreLabel == "Fantasy");
    assert (searchBookPageState.dropdownGenreValue == BookGenres().allBookGenres.indexOf("Fantasy") + 1);

    expect(find.byType(TextButton), findsNWidgets(2));

    assert( searchBookPageState.isRemoveFilterEnabled == false);
    await tester.tap(find.byType(TextButton).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert( searchBookPageState.isRemoveFilterEnabled == true);

    await tester.tap(find.byType(ManuallyCloseableExpansionTile).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    assert( searchBookPageState.lessThanPrice != "");
    assert( searchBookPageState.greaterThanPrice != "");
    assert( searchBookPageState.isbnFilter != "");
    assert( searchBookPageState.photosCheckBox == true);
    assert( searchBookPageState.exchangeableCheckBox == true);
    await tester.tap(find.byType(TextButton).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert( searchBookPageState.isRemoveFilterEnabled == false);
    assert( searchBookPageState.lessThanPrice == "");
    assert( searchBookPageState.greaterThanPrice == "");
    assert( searchBookPageState.isbnFilter == "");
    assert( searchBookPageState.photosCheckBox == false);
    assert( searchBookPageState.exchangeableCheckBox == false);


    expect(find.byType(CustomRadioButton), findsNothing);
    await tester.tap(find.byType(ManuallyCloseableExpansionTile).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(CustomRadioButton), findsOneWidget);
    assert (searchBookPageState.selectedOrder == orderByNoOrderLabel);
    assert (searchBookPageState.selectedOrderValue == orderByBookLabels.indexOf(orderByNoOrderLabel));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == orderByLanguageLabel), findsOneWidget);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.data == orderByLanguageLabel));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.selectedOrder == orderByLanguageLabel);
    assert (searchBookPageState.selectedOrderValue == orderByBookLabels.indexOf(orderByLanguageLabel));

    await tester.tap(find.byType(ManuallyCloseableExpansionTile).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.dropdownValue == orderByAscendingWayValue);
    assert (searchBookPageState.selectedOrderWay == orderByAscendingWay);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.key ==  ValueKey("OrderByAscendingItem")).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.key ==  ValueKey("OrderByDescendingItem")).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchBookPageState.dropdownValue == orderByDescendingWayValue);
    assert (searchBookPageState.selectedOrderWay == orderByDescendingWay);

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

}