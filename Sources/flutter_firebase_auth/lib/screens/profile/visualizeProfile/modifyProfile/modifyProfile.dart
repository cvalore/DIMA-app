import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/modifyProfile/changeProfilePic.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/enums.dart';
import 'package:flutter_firebase_auth/utils/stringWrapper.dart';
import 'package:provider/provider.dart';

class ModifyProfile extends StatefulWidget {
  static const routeName = '/modifyProfile';

  CustomUser user;
  StringWrapper newImagePath = StringWrapper();
  StringWrapper fullName = StringWrapper();
  UserGender gender;
  DateTime birthday;

  ModifyProfile({Key key, @required this.user});

  @override
  _ModifyProfileState createState() => _ModifyProfileState();
}

class _ModifyProfileState extends State<ModifyProfile> {

  @override
  Widget build(BuildContext context) {

    widget.newImagePath != null ? print(widget.newImagePath.value) : print('null value');
    DatabaseService _db = DatabaseService(user: widget.user);

    return Scaffold(
      appBar: AppBar(
        title: Text('Modify profile'),
        actions: [
          IconButton(
              icon: Icon(Icons.check_outlined),
              //TODO save user changes on the db
              onPressed: () async {
                await _db.updateUserInfo(widget.newImagePath.value);
                Navigator.pop(context);
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChangeProfilePic(height: 120.0, username: widget.user.username, newImagePath: widget.newImagePath, oldImageURL: widget.user.userProfileImageURL,),
            //VisualizeProfile(height: 120.0),
            Divider(height: 15, thickness: 2,),
            //customSizedBox(10.0, Colors.black),
            //customSizedBox(1.0, Colors.white),
            //Favorites(height: 60.0),
            Divider(height: 15, thickness: 2,),
            //customSizedBox(10.0, Colors.black),
            //customSizedBox(1.0, Colors.white),
            //Orders(height: 60.0),
            Divider(height: 15, thickness: 2,),
          ],
        ),
      ),
    );
  }
}
