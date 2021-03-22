import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/comment.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeMyProfile/profileHomePage.dart';
import 'package:flutter_firebase_auth/screens/wrapper.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/screens/authenticate/subscribe.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
  }
  
 class App extends StatefulWidget {
   @override
   _AppState createState() => _AppState();
 }
 
 class _AppState extends State<App> {
   // Set default `_initialized` and `_error` state to false
   bool _initialized = false;
   bool _error = false;

   // Define an async function to initialize FlutterFire
   void initializeFlutterFire() async {
     try {
       // Wait for Firebase to initialize and set `_initialized` state to true
       await Firebase.initializeApp();
       setState(() {
         _initialized = true;
       });
     } catch (e) {
       // Set `_error` state to true if Firebase initialization fails
       setState(() {
         _error = true;
       });
     }
   }

     @override
     void initState() {
       initializeFlutterFire();
       super.initState();
     }

     @override
     Widget build(BuildContext context) {
       // Show error message if initialization failed
       if(_error) {
         return Text('error',
           textDirection: TextDirection.ltr,);
       }

       // Show a loader until FlutterFire is initialized
       if (!_initialized) {
         return Loading();
       }
       return StreamProvider<CustomUser>.value(
         value: AuthService().userStream,
         child: MaterialApp(
           theme: ThemeData(
             buttonColor: Colors.white12,
             //primarySwatch: Colors.blueGrey[600],
             buttonTheme: const ButtonThemeData(
               textTheme: ButtonTextTheme.primary
             )
           ),
           home: Wrapper(),
           routes: {
             MyBooks.routeName: (context) => MyBooks(),
             Subscribe.routeName: (context) => Subscribe(),
             CommentBox.routeName: (context) => CommentBox(),
             CategoryBox.routeName: (context) => CategoryBox(),
             PriceBox.routeName: (context) => PriceBox(),
             ProfileHomePage.routeName: (context) => ProfileHomePage(),
           }
         ),
       );
     }
 }