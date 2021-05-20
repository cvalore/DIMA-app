import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchUserPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:radio_grouped_buttons/custom_buttons/custom_radio_buttons_group.dart';

void main() {

  testWidgets("SearchUserPage Test", (WidgetTester tester) async {
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
      child: Builder(builder: (BuildContext context) {
        return SearchUserPage(key: _childKey, );
      },),
    ),),));

    SearchUserPageState searchUserPageState = tester.state(find.byType(SearchUserPage));
    assert (searchUserPageState.openModifiersSection == false);
    assert (searchUserPageState.dropdownValue == orderByAscendingWayValue);
    assert (searchUserPageState.selectedOrderWay == orderByAscendingWay);
    assert (searchUserPageState.selectedOrderValue == 0);
    assert (searchUserPageState.selectedOrder == orderByNoOrderLabel);
    assert (searchUserPageState.searchUsername == "");
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == searchUserPageState.resultMessage), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "searchUserBtn"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.keyboard_arrow_down), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ManuallyCloseableExpansionTile), findsNothing);

    await tester.enterText(find.byType(TextFormField), "prova");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchUserPageState.searchUsername == "prova");

    await tester.tap(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.keyboard_arrow_down));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchUserPageState.openModifiersSection == true);
    expect(find.byType(ManuallyCloseableExpansionTile), findsOneWidget);

    expect(find.byType(CustomRadioButton), findsNothing);
    await tester.tap(find.byType(ManuallyCloseableExpansionTile).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(CustomRadioButton), findsOneWidget);


    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == orderByStarsLabel), findsOneWidget);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.data == orderByStarsLabel));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchUserPageState.selectedOrder == orderByStarsLabel);
    assert (searchUserPageState.selectedOrderValue == orderByUsersLabels.indexOf(orderByStarsLabel));

    await tester.tap(find.byType(ManuallyCloseableExpansionTile).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.key == ValueKey("OrderByAscendingItem")).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.key == ValueKey("OrderByDescendingItem")).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    assert (searchUserPageState.dropdownValue == orderByDescendingWayValue);
    assert (searchUserPageState.selectedOrderWay == orderByDescendingWay);


    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

}