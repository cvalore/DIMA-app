import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/paymentInfo/savedPaymentMethod.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view payment methods from profile', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    List<Map<String, dynamic>> paymentMethods = [{'ownerName': 'Alessio Russo', 'expiringDate': '11/22', 'cardNumber':'0000 1111 2222 3333', 'securityCode':'100'},
      {'ownerName': 'Carmelo Valore', 'expiringDate': '11/30', 'cardNumber':'0000 1111 4444 5555', 'securityCode':'200'}];

    SavedPaymentMethod savedPaymentMethod = SavedPaymentMethod(savedPaymentMethods: paymentMethods);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: savedPaymentMethod)));

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new card'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);
    expect(find.byType(RadioListTile), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Alessio Russo'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Carmelo Valore'), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == '**** **** **** 3333\t   11/22'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is ListTile).at(2));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Payment method info'), findsOneWidget);


    expect(find.byWidgetPredicate((widget) => widget is TextFormField), findsNWidgets(4));

    expect(find.text('Carmelo Valore'), findsOneWidget);
    expect(find.text('11/30'), findsOneWidget);
    expect(find.text('0000 1111 4444 5555'), findsOneWidget);
    expect(find.text('200'), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Add new card'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.add_circle_outlined), findsOneWidget);

  });

}