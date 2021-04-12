import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/modifyProfile/changeProfilePic.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/boolWrapper.dart';
import 'package:flutter_firebase_auth/utils/stringWrapper.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:intl/intl.dart';

class ModifyProfileMainPage extends StatefulWidget {
  static const routeName = '/modifyProfile';

  CustomUser user;
  StringWrapper newImagePath = StringWrapper(value: '');
  String fullName = '';
  String birthdayString = '';
  String bio = '';
  String city = '';
  BoolWrapper isOldImageRemoved = BoolWrapper(value: false);

  ModifyProfileMainPage({Key key, @required this.user});

  @override
  _ModifyProfileMainPageState createState() => _ModifyProfileMainPageState();
}

class _ModifyProfileMainPageState extends State<ModifyProfileMainPage> {

  @override
  void initState() {
    if (widget.user.fullName != '') widget.fullName = widget.user.fullName;
    if (widget.user.birthday != '') widget.birthdayString = widget.user.birthday;
    if (widget.user.bio != '') widget.bio = widget.user.bio;
    if (widget.user.city != '') widget.city = widget.user.city;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;
    DatabaseService _db = DatabaseService(user: widget.user);

    return Scaffold(
      appBar: AppBar(
        title: Text('Modify profile'),
        actions: [
          IconButton(
              icon: Icon(Icons.check_outlined),
              onPressed: () async {
                if (widget.birthdayString != '')
                  widget.birthdayString = Utils.isDateValid(widget.birthdayString) ? widget.birthdayString : '';
                if (widget.newImagePath.value != '')
                  await Utils.saveNewImageProfile(widget.newImagePath.value);
                await _db.updateUserInfo(widget.newImagePath.value,
                    widget.isOldImageRemoved.value,
                    widget.fullName,
                    widget.birthdayString,
                    widget.bio,
                    widget.city);
                Navigator.pop(context);
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChangeProfilePic(height: 120.0,
              username: widget.user.username,
              newImagePath: widget.newImagePath,
              oldImagePath: widget.user.userProfileImagePath,
              oldImageRemoved: widget.isOldImageRemoved,
            ),
            Divider(height: 20, thickness: 2,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextFormField(
                initialValue: widget.user.fullName == '' ? null : widget.user.fullName,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 16,
                      //color: Colors.white
                  ),
                  labelText: "Name and Surname",
                  //hintStyle: TextStyle(color: Colors.white,),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                      //borderSide: BorderSide(color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      //borderSide: BorderSide(color: Colors.white)
                  ),
                  filled: true,
                  //fillColor: Colors.white24,
                ),
                //style: TextStyle(color: Colors.white),
                validator: (value) =>
                (value.isEmpty ||
                    !value.contains(' ')
                    ) ?
                'Enter a valid name' : null,
                onChanged: (value) {
                  if(value != '') {
                    setState(() {
                      widget.fullName = value;
                    });
                  }
                },
              ),
            ),
            Divider(height: 20, thickness: 2,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextFormField(
                initialValue: widget.user.birthday == '' ? null : widget.user.birthday,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'dd/mm/yyyy',
                  labelStyle: TextStyle(fontSize: 16,
                      //color: Colors.white
                  ),
                  labelText: "Birthday",
                  //hintStyle: TextStyle(color: Colors.white,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    //borderSide: BorderSide(color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //borderSide: BorderSide(color: Colors.white)
                  ),
                  filled: true,
                  //fillColor: Colors.white24,
                ),
                //style: TextStyle(color: Colors.white),
                validator: (value) =>
                (value.isNotEmpty && (!value.contains('/') ||
                    value.contains('/') && value.split('/').length != 3 ||
                    Utils.isDateValid(value) == false)
                ) ? 'Enter a valid date or leave this field empty' : null,
                onChanged: (value) {
                  if(value != '') {
                    setState(() {
                      widget.birthdayString = value;
                    });
                  }
                },
              ),
            ),
            Divider(height: 20, thickness: 2,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextFormField(
                initialValue: widget.user.city == '' ? null : widget.user.city,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 16,
                    //color: Colors.white
                  ),
                  labelText: "City",
                  //hintStyle: TextStyle(color: Colors.white,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    //borderSide: BorderSide(color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //borderSide: BorderSide(color: Colors.white)
                  ),
                  filled: true,
                  //fillColor: Colors.white24,
                ),
                //style: TextStyle(color: Colors.white),
                validator: (value) =>
                (value.isEmpty ||
                    !value.contains(' ')
                ) ?
                'Enter a valid name' : null,
                onChanged: (value) {
                  if(value != '') {
                    setState(() {
                      widget.city = value;
                    });
                  }
                },
              ),
            ),
            Divider(height: 20, thickness: 2,),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextFormField(
                maxLines: 4,
                initialValue: widget.user.bio == '' ? null: widget.user.bio,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'About me',
                  labelStyle: TextStyle(fontSize: 16,
                      //color: Colors.white
                  ),
                  labelText: "Bio",
                  //hintStyle: TextStyle(color: Colors.white,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    //borderSide: BorderSide(color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //borderSide: BorderSide(color: Colors.white)
                  ),
                  filled: true,
                  //fillColor: Colors.white24,
                ),
                //style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  if(value != '') {
                    setState(() {
                      widget.bio = value;
                    });
                  }
                },
              ),
            ),
            Divider(height: 15, thickness: 2,),
          ],
        ),
      ),
    );
  }
}
