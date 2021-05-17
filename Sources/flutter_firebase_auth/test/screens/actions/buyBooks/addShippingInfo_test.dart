import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewShippingInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addShippingInfo.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('add shipping address and selecting it when buying item', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    List<Map<String, dynamic>> shippingAddresses = [{'CAP': '82020', 'address 1': 'Gaetano Longo street, N 2', 'address 2':'First floor', 'fullName':'Alessio Russo', 'state':'Italy'},
                                                    {'CAP': '20068', 'address 1': 'Ugo La Malfa street, N 1', 'address 2':'Russo family', 'fullName':'Carmelo Valore', 'state':'Italy'}];

    AddShippingInfo addShippingInfo = AddShippingInfo(savedShippingAddress: shippingAddresses);
    Map<String, String> resultFromPop = {'CAP': '', 'address 1': '', 'address 2':'', 'fullName':'', 'state':'', 'city':''};
    int numberOfSavedAddresses;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (BuildContext context) {
      return  ElevatedButton(
        onPressed: () async {
          List<dynamic> result;
          result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return addShippingInfo;
          }));

          if (result != null) {
            numberOfSavedAddresses = result[0].length;
            resultFromPop['CAP'] = result[1]['CAP'];
            resultFromPop['address 1'] = result[1]['address 1'];
            resultFromPop['address 2'] = result[1]['address 2'];
            resultFromPop['fullName'] = result[1]['fullName'];
            resultFromPop['state'] = result[1]['state'];
            resultFromPop['city'] = result[1]['city'];
          }
        }, child: Text('Button'),
      );
    }),)));

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new shipping address'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);
    expect(find.byType(RadioListTile), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Alessio Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Carmelo Valore'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Gaetano Longo street, N 2'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is ListTile).first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Shipping info'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Choose address'), findsNothing);

    final AddNewShippingInfoState addNewShippingInfoState = tester.state(find.byType(AddNewShippingInfo));

    print(addNewShippingInfoState.infoState);

    expect(find.byType(DropdownMenuItem), findsNothing);
    expect(find.byType(DropdownButton), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is DropdownButton), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is DropdownMenuItem), findsNWidgets(10));

    expect(find.byWidgetPredicate((widget) => widget is DropdownButton && widget.value == null), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is DropdownButton && widget.value == 'Italy'), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is DropdownButton && widget.isExpanded == true), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is DropdownMenuItem && widget.value == 'Italy'), findsOneWidget);

    expect(find.text('Select a state'), findsOneWidget);
    await tester.tap(find.text('Select a state'));
    await tester.pump();
    await tester.tap(find.text('Italy').last);
    await tester.pump();
    expect(addNewShippingInfoState.infoState['state'], 'Italy');

    // the name has a bad format
    await tester.enterText(find.byType(TextFormField).first, 'ManuelRusso');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid name'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Manuel Russo');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid name'), findsNothing);
    expect(addNewShippingInfoState.infoState['fullName'], 'Manuel Russo');

    // address 1 should not be empty
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid address'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'G. Pascoli street');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid address'), findsNothing);
    expect(addNewShippingInfoState.infoState['address 1'], 'G. Pascoli street');

    // address 2 may be also empty
    await tester.enterText(find.byType(TextFormField).at(2), 'second building');
    await tester.pump();
    expect(addNewShippingInfoState.infoState['address 2'], 'second building');

    // CAP consists of 5 digits
    await tester.enterText(find.byType(TextFormField).at(3), '123');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid CAP'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(3), '20001');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid CAP'), findsNothing);
    expect(addNewShippingInfoState.infoState['CAP'], '20001');

    // city should not be empty
    await tester.enterText(find.byType(TextFormField).at(4), '');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid city'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(4), '   ');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid city'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(4), 'Chieti');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SaveShippingAddressButton')));
    await tester.pump();
    expect(find.text('Enter a valid city'), findsNothing);
    expect(addNewShippingInfoState.infoState['city'], 'Chieti');

    print(addNewShippingInfoState.infoState);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(ListTile), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new shipping address'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);
    expect(find.byType(RadioListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Alessio Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Carmelo Valore'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Manuel Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'G. Pascoli street'), findsOneWidget);

    await tester.tap(find.byType(RadioListTile).at(2));
    await tester.pump();

    expect(numberOfSavedAddresses, 3);

    expect(resultFromPop['fullName'], 'Manuel Russo');
    expect(resultFromPop['address 1'], 'G. Pascoli street');
    expect(resultFromPop['address 2'], 'second building');
    expect(resultFromPop['CAP'], '20001');
    expect(resultFromPop['city'], 'Chieti');

  });

}