import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/mainPage.dart';

class AppLifecycleReactor extends StatefulWidget {
  @override
  _AppLifecycleReactorState createState() => _AppLifecycleReactorState();
}

class _AppLifecycleReactorState extends State<AppLifecycleReactor> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    if(WidgetsBinding.instance != null) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    if(WidgetsBinding.instance != null) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() { _notification = state; });
  }

  @override
  Widget build(BuildContext context) {
    //print("Last notification: " + _notification.toString());
    return MainPage();
  }
}
