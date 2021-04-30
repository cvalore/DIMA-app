import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/mainPage.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/networkStatusService.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /*runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => App(),
    )
  );*/
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
     Utils.init();
     super.initState();
   }

   @override
   Widget build(BuildContext context) {
     // Show error message if initialization failed
     if(_error) {
       return Center(
         child: Text('error',
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
         ),
       );
     }

     // Show a loader until FlutterFire is initialized
     if (!_initialized) {
       return Loading();
     }

     return StreamProvider<NetworkStatus>(
        create: (context) =>
          NetworkStatusService().networkStatusController.stream,
        child: MainPage(),
     );
   }
 }