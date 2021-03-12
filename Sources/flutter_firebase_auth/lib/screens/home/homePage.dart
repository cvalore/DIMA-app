import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/profile/profile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blueGrey[400];
                      }
                      else {
                        return Colors.blueGrey[600];
                      }
                    }),
              ),
              child: Text('To user profile', style: TextStyle(color: Colors.white),),
              onPressed: () {
                if(user != null && !user.isAnonymous) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                }
                else {
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                        'You need to be logged in to access your profile'
                    ),
                  );
                  // Find the Scaffold in the widget tree and use
                  // it to show a SnackBar.
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
            ),
            TextButton(
              style: ButtonStyle(
                //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blueGrey[400];
                      }
                      else {
                        return Colors.blueGrey[600];
                      }
                    }),
              ),
              child: Text('To insertBook page', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookInsert()),
                );
              },
            ),
            TextButton(
              style: ButtonStyle(
                //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blueGrey[400];
                      }
                      else {
                        return Colors.blueGrey[600];
                      }
                    }),
              ),
              child: Text('To addImage page', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageService()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
