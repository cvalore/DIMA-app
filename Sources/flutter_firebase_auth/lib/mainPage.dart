import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/comment.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/screens/actions/addUserReview.dart';
import 'package:flutter_firebase_auth/screens/authenticate/subscribe.dart';
import 'package:flutter_firebase_auth/screens/wrapper.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/utils/networkStatusService.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);

    return
      networkStatus == NetworkStatus.Offline ?
      MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              brightness: Brightness.dark,
              //scaffoldBackgroundColor: Colors.grey,
              textTheme: TextTheme(
                headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                bodyText1: TextStyle(fontSize: 22.0),
                bodyText2: TextStyle(fontSize: 16.0,),
              ),
              //buttonColor: Colors.blueAccent,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.blueAccent
              ),
              snackBarTheme: SnackBarThemeData(
                actionTextColor: Colors.white,
              ),
              //buttonColor: Colors.white12,
              //buttonTheme: const ButtonThemeData()
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.red;
                        return Colors.blueGrey; // Defer to the widget's default.
                      }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.grey;
                        return null; // Defer to the widget's default.
                      }),

                ),

              ),

              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        );
                      }
                  ),
                  textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                          (Set<MaterialState> states) {
                        return TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        );
                      }),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white70;
                        }
                        else if(states.contains(MaterialState.disabled)) {
                          return Colors.white12;
                        }
                        else {
                          return Colors.white;
                        }
                      }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black;
                        }
                        else if(states.contains(MaterialState.disabled)) {
                          return Colors.white12;
                        }
                        else {
                          return Colors.black;
                        }
                      }),
                ),
              )
          ),
          home: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('BookYourBook', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                letterSpacing: 1.0,
              ),),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("No internet connection available"),
                  Icon(Icons.signal_cellular_connected_no_internet_4_bar_outlined),
                ],
              ),
            ),
          ),
          routes: {
            Subscribe.routeName: (context) => Subscribe(),
            CommentBox.routeName: (context) => CommentBox(),
            CategoryBox.routeName: (context) => CategoryBox(),
            PriceBox.routeName: (context) => PriceBox(),
            //ProfileHomePage.routeName: (context) => ProfileHomePage(),
            AddUserReview.routeName: (context) => AddUserReview(),
          }
      ) :
      StreamProvider<AuthCustomUser>.value(
      value: AuthService().userStream,
      child: MaterialApp(
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              brightness: Brightness.dark,
              //scaffoldBackgroundColor: Colors.grey,
              textTheme: TextTheme(
                headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                bodyText1: TextStyle(fontSize: 22.0),
                bodyText2: TextStyle(fontSize: 16.0,),
              ),
              //buttonColor: Colors.blueAccent,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
              ),
              snackBarTheme: SnackBarThemeData(
                actionTextColor: Colors.white,
              ),
              //buttonColor: Colors.white12,
              //buttonTheme: const ButtonThemeData()
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.red;
                        return Colors.teal[600]; // Defer to the widget's default.
                      }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.grey;
                        return null; // Defer to the widget's default.
                      }),

                ),

              ),

              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        );
                      }
                  ),
                  textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                          (Set<MaterialState> states) {
                        return TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        );
                      }),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white70;
                        }
                        else if(states.contains(MaterialState.disabled)) {
                          return Colors.white12;
                        }
                        else {
                          return Colors.white;
                        }
                      }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black;
                        }
                        else if(states.contains(MaterialState.disabled)) {
                          return Colors.white12;
                        }
                        else {
                          return Colors.black;
                        }
                      }),
                ),
              )
          ),
          home: Wrapper(),
          routes: {
            Subscribe.routeName: (context) => Subscribe(),
            CommentBox.routeName: (context) => CommentBox(),
            CategoryBox.routeName: (context) => CategoryBox(),
            PriceBox.routeName: (context) => PriceBox(),
            //ProfileHomePage.routeName: (context) => ProfileHomePage(),
            AddUserReview.routeName: (context) => AddUserReview(),
          }
      ),
    );
  }
}
