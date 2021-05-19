import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewShippingInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addShippingInfo.dart';
import 'package:flutter_firebase_auth/screens/profile/shippingAddress/savedShippingAddress.dart';
import 'package:flutter_firebase_auth/screens/profile/shippingAddress/shippingAddress.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view saved shipping addresses from profile', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    List<dynamic> shippingAddresses = [{'CAP': '82020', 'address 1': 'Gaetano Longo street, N 2', 'address 2':'First floor', 'fullName':'Alessio Russo', 'state':'Italy'},
      {'CAP': '20068', 'address 1': 'Ugo La Malfa street, N 1', 'address 2':'Russo family', 'fullName':'Carmelo Valore', 'state':'Italy'}];

    SavedShippingAddress savedShippingAddress = SavedShippingAddress(savedShippingAddress: shippingAddresses);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: savedShippingAddress)));
    
    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new shipping address'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);
    expect(find.byType(RadioListTile), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Alessio Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Carmelo Valore'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Gaetano Longo street, N 2'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is ListTile).at(1));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    AddNewShippingInfoState addNewShippingInfoState = tester.state(find.byType(AddNewShippingInfo));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Shipping info'), findsOneWidget);

    expect(find.byType(DropdownMenuItem), findsNothing);
    expect(find.byType(DropdownButton), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is DropdownButton), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is DropdownMenuItem), findsNothing);

    expect(find.text('Select a state'), findsNothing);

    expect(find.text('Alessio Russo'), findsOneWidget);
    expect(find.text('Gaetano Longo street, N 2'), findsOneWidget);
    expect(find.text('82020'), findsOneWidget);
    expect(find.text('First floor'), findsOneWidget);
    expect(find.text('Italy'), findsOneWidget);

    expect(find.byType(ListTile), findsNothing);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new shipping address'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);

  });

}