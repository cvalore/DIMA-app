import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/utils/stringWrapper.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePic extends StatefulWidget {

  double height;
  String username;
  StringWrapper newImagePath;
  String oldImagePath;

  ChangeProfilePic({Key key, @required this.height, @required this.username, @required this.newImagePath, @required this.oldImagePath});

  @override
  _ChangeProfilePicState createState() => _ChangeProfilePicState();
}

class _ChangeProfilePicState extends State<ChangeProfilePic> {

  final ImagePicker _picker = ImagePicker();

  _imgFromCamera() async {
    PickedFile image = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50
    );

    if(image != null) {
      setState(() {
        widget.newImagePath.value = image.path;
        //widget.user.userProfileImagePath = image.path;
      });
    }
  }

  _imgFromGallery() async {
    PickedFile image = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50
    );

    if(image != null) {
      setState(() {
          widget.newImagePath.value = image.path;
          print(image.path);
          //widget.user.userProfileImagePath = image.path;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library, color: Colors.white,),
                      title: new Text('Photo Library', style: TextStyle(color: Colors.white),),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera, color: Colors.white),
                    title: new Text('Camera', style: TextStyle(color: Colors.white),),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    print('old image path is');
    print(widget.oldImagePath);

    return Container(
        height: widget.height,
        child: GestureDetector(
          onTap: () async {
            _showPicker(context);
          },
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: widget.newImagePath.value != '' ?
                        CircleAvatar(
                          radius: 50,
                          child: CircleAvatar(
                              radius: 50,
                            backgroundImage: FileImage(File(widget.newImagePath.value))
                          ),
                        ) : widget.oldImagePath != '' ?  CircleAvatar(
                          radius: 50,
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(File(widget.oldImagePath))
                          ),
                        ) : CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.brown.shade800,
                          child: Text(
                            widget.username[0].toUpperCase(),
                            textScaleFactor: 3,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Text('Change profile picture',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward_ios,
                    //color: Colors.white
                ),
              )
            ],
          ),
        )
    );
  }
}



