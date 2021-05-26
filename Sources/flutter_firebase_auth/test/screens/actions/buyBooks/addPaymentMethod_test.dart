import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewPaymentMethod.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addPaymentMethod.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('add payment method and selecting it when buying item', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    List<Map<String, dynamic>> paymentMethods = [{'ownerName': 'Alessio Russo', 'expiringDate': '11/22', 'cardNumber':'0000 1111 2222 3333', 'securityCode':'100'},
    {'ownerName': 'Carmelo Valore', 'expiringDate': '11/30', 'cardNumber':'0000 1111 4444 5555', 'securityCode':'200'}];

    AddPaymentMethod addPaymentMethod = AddPaymentMethod(savedPaymentMethods: paymentMethods);
    Map<String, String> resultFromPop =     {'ownerName': '', 'expiringDate': '', 'cardNumber':'', 'securityCode':''};
    int numberOfSavedPaymentMethods;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (BuildContext context) {
      return  ElevatedButton(
        onPressed: () async {
          List<dynamic> result;
          result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return addPaymentMethod;
          }));

          if (result != null) {
            numberOfSavedPaymentMethods = result[0].length;
            resultFromPop['ownerName'] = result[1]['ownerName'];
            resultFromPop['expiringDate'] = result[1]['expiringDate'];
            resultFromPop['cardNumber'] = result[1]['cardNumber'];
            resultFromPop['securityCode'] = result[1]['securityCode'];
          }
        }, child: Text('Button'),
      );
    }),)));

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new card'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);
    expect(find.byType(RadioListTile), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Alessio Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Carmelo Valore'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == '**** **** **** 3333\t   11/22'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is ListTile).first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Payment method info'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Payment cards'), findsNothing);

    final AddNewPaymentMethodState addNewPaymentMethodState = tester.state(find.byType(AddNewPaymentMethod));

    print(addNewPaymentMethodState.infoState);

    expect(find.byWidgetPredicate((widget) => widget is TextFormField), findsNWidgets(4));

    // owner name has bad format
    await tester.enterText(find.byType(TextFormField).first, 'ManuelRusso');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid name'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Manuel Russo');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid name'), findsNothing);
    expect(addNewPaymentMethodState.infoState['ownerName'], 'Manuel Russo');

    // card number has bad format
    await tester.enterText(find.byType(TextFormField).at(1), '111 222 3 333');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid card number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), '1234 1234 1234 1234');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid card number'), findsNothing);
    expect(addNewPaymentMethodState.infoState['cardNumber'], '1234 1234 1234 1234');

    // expiring data has bad format
    await tester.enterText(find.byType(TextFormField).at(2), '2121');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid expiring date'), findsOneWidget);

    // expiring date is a past date
    await tester.enterText(find.byType(TextFormField).at(2), '10/20');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid expiring date'), findsOneWidget);

    // expiring date has a bad format
    await tester.enterText(find.byType(TextFormField).at(2), '13/20');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid expiring date'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(2), '10/30');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid expiring date'), findsNothing);
    expect(addNewPaymentMethodState.infoState['expiringDate'], '10/30');


    // security code must have 3 or 4 digits
    await tester.enterText(find.byType(TextFormField).at(3), '30200');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid security code'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(3), '207');
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((widget) => widget is IconButton && widget.key == ValueKey('SavePaymentMethod')));
    await tester.pump();
    expect(find.text('Enter a valid security code'), findsNothing);
    expect(addNewPaymentMethodState.infoState['securityCode'], '207');
    await tester.pump(const Duration(seconds: 10));


    expect(find.byType(ListTile), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new card'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);
    expect(find.byType(RadioListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Alessio Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Carmelo Valore'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Manuel Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == '**** **** **** 1234\t   10/30'), findsOneWidget);

    await tester.tap(find.byType(RadioListTile).at(2));
    await tester.pump();

    expect(numberOfSavedPaymentMethods, 3);

    expect(resultFromPop['ownerName'], 'Manuel Russo');
    expect(resultFromPop['cardNumber'], '1234 1234 1234 1234');
    expect(resultFromPop['expiringDate'], '10/30');
    expect(resultFromPop['securityCode'], '207');

  });

}