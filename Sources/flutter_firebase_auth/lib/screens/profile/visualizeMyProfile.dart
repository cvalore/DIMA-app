import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeMyProfile/profileHomePage.dart';
import 'package:flutter_firebase_auth/services/database.dart';

class VisualizeMyProfile extends StatefulWidget {

  double height;
  CustomUser user;
  //Image avatar;

  VisualizeMyProfile({Key key, @required this.user, @required this.height}) : super(key: key);

  @override
  _VisualizeMyProfileState createState() => _VisualizeMyProfileState();
}

class _VisualizeMyProfileState extends State<VisualizeMyProfile> {
  @override
  Widget build(BuildContext context) {
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
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage('http://i.imgur.com/QSev0hg.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.red,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(widget.user.username),
                        Text('Recensioni?')
                      ],
                    )
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


