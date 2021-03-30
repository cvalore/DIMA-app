import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:provider/provider.dart';

class VisualizeProfile extends StatefulWidget {

  double height;
  //Image avatar;

  VisualizeProfile({Key key, @required this.height}) : super(key: key);

  @override
  _VisualizeProfileState createState() => _VisualizeProfileState();
}

class _VisualizeProfileState extends State<VisualizeProfile> {
  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    DatabaseService _db = DatabaseService(user: user);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: widget.height,
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisualizeProfileMainPage(user: user, self: true))
          );
          /*
          setState(() {
            if(result != null)
              print('to modify');
          });

           */
        },
        child: user == null ? Loading() :
        Row(
          children: [
            Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60.0,
                        child: CircleAvatar(
                          backgroundImage: user.userProfileImageURL != '' ?
                            NetworkImage(user.userProfileImageURL) :
                            AssetImage('assets/images/no_image_available.png'),
                          radius: 60.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.username,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
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


