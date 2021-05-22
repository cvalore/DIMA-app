import 'package:flutter/material.dart';
// The application under test.
import 'package:flutter_firebase_auth/main.dart' as app;
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/authenticate/register.dart';
import 'package:flutter_firebase_auth/screens/authenticate/signIn.dart';
import 'package:flutter_firebase_auth/screens/authenticate/subscribe.dart';
import 'package:flutter_firebase_auth/screens/home/home.dart';
import 'package:flutter_firebase_auth/screens/home/homeBody.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
import 'package:flutter_firebase_auth/screens/wrapper.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Utils.mockedDb = true;
  Utils.mySelf = CustomUser("");
  Utils.databaseService = DatabaseService();

  testWidgets('SignUp - SignIn - email and password', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(15000, 16000);

    app.main();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(SignIn), findsOneWidget);
    expect(find.byType(Register), findsNothing);

    final createAccountText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Create account");
    await tester.tap(createAccountText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(SignIn), findsNothing);
    expect(find.byType(Register), findsOneWidget);
    expect(find.byType(Wrapper), findsOneWidget);


    final emailSignUpTextFormField = find.byType(TextFormField).first;
    final passwordSignUpTextFormField = find.byType(TextFormField).last;
    await tester.enterText(emailSignUpTextFormField, "testEmail@gmail.com");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(passwordSignUpTextFormField, "testPassword1234");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final signUpText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Sign Up");
    await tester.tap(signUpText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(Register), findsNothing);
    expect(find.byType(Subscribe), findsOneWidget);

    final usernameTextField = find.byType(TextFormField).first;
    final signUpSubscribeText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Sign Up");
    await tester.enterText(usernameTextField, "testUsername");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(signUpSubscribeText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    WrapperState wrapperWidget = tester.state(find.byType(Wrapper));
    wrapperWidget.rebuildForTest();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(Subscribe), findsNothing);
    expect(find.byType(Home), findsOneWidget);

    final logoutIcon = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.logout);
    expect(logoutIcon, findsOneWidget);
    await tester.tap(logoutIcon);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    wrapperWidget.rebuildForTest();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(Home), findsNothing);
    expect(find.byType(SignIn), findsOneWidget);

    final emailSignInTextFormField = find.byType(TextFormField).first;
    final passwordSignInTextFormField = find.byType(TextFormField).last;
    await tester.enterText(emailSignInTextFormField, "testEmail@gmail.com");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(passwordSignInTextFormField, "testPassword1234");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final signInText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Sign In");
    await tester.tap(signInText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    wrapperWidget.rebuildForTest();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(SignIn), findsNothing);
    expect(find.byType(Home), findsOneWidget);

    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}