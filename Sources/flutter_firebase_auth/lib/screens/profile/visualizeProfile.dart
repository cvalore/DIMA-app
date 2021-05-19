
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class VisualizeProfile extends StatefulWidget {

  double height;

  VisualizeProfile({Key key, @required this.height}) : super(key: key);

  @override
  _VisualizeProfileState createState() => _VisualizeProfileState();
}

class _VisualizeProfileState extends State<VisualizeProfile> {

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);

    DatabaseService _db = DatabaseService(user: user);


    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return user != null ?
    FutureBuilder(
        future: Utils.setUserProfileImagePath(user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              height: _isPortrait ? widget.height : MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight - 20,
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StreamProvider<CustomUser>.value(
                                                                  value: _db.userInfo,
                                                                  child: VisualizeProfileMainPage(self: true))
                    )
                  );
                },
                child:
                _isPortrait ?
                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CircleAvatar(
                                backgroundColor: Colors.teal[100],
                                radius: 60.0,
                                child: user.userProfileImagePath != null && user.userProfileImagePath != '' ?
                                CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: NetworkImage(user.userProfileImageURL),
                                    //FileImage(File(user.userProfileImagePath))
                                ) : Text(
                                  user.username[0].toUpperCase(),
                                  textScaleFactor: 3,
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
                ) :
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.teal[100],
                      radius: 60.0,
                      child: user.userProfileImagePath != null && user.userProfileImagePath != '' ?
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(user.userProfileImageURL),
                        //FileImage(File(user.userProfileImagePath))
                      ) : Text(
                        user.username[0].toUpperCase(),
                        textScaleFactor: 3,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(user.username,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    )
                  ],
                ),
              ),
            );
      }
    }
    ) : Container();
  }
}