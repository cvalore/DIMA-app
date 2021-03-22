import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeMyProfile/profileHomePage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';

class VisualizeMyProfile extends StatefulWidget {

  double height;
  CustomUser user;
  //Image avatar;

  VisualizeMyProfile({Key key, @required this.height}) : super(key: key);

  @override
  _VisualizeMyProfileState createState() => _VisualizeMyProfileState();
}

class _VisualizeMyProfileState extends State<VisualizeMyProfile> {
  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    DatabaseService _db = DatabaseService(); //here we need the user uid

    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: () async {
          dynamic result = await Navigator.pushNamed(context, ProfileHomePage.routeName,
              //arguments: widget.insertedBook.category
          );
          setState(() {
            if(result != null)
              print('to modify');
             // widget.insertedBook.setCategory(result);
          });
        },
        child: Row(
          children: [
            Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: user.userProfileImagePath == null ?
                              AssetImage('assets/images/no_image_available.png') :
                              AssetImage('assets/images/no_image_available.png'),    //TODO nell'else qui mettere un'immagine dell'utente
                            fit: BoxFit.contain,
                          ),
                          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                          /*
                          border: new Border.all(
                            color: Colors.red,
                            width: 4.0,
                          ),

                           */
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(user.username,
                            style: TextStyle(
                              color: Colors.white70
                            ),
                          ),
                          Text('Recensioni?')
                        ],
                      )
                    ),
                  ],
                )
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}


