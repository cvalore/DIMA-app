import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/boolWrapper.dart';
import 'package:flutter_firebase_auth/utils/stringWrapper.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePic extends StatefulWidget {

  double height;
  String username;
  StringWrapper newImagePath;
  String oldImagePath;
  BoolWrapper oldImageRemoved;

  ChangeProfilePic({Key key, @required this.height, @required this.username, @required this.newImagePath, @required this.oldImagePath, @required this.oldImageRemoved});

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

    widget.oldImagePath = widget.oldImagePath == null ? '' : widget.oldImagePath;

    return Container(
        height: widget.height,
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
                        backgroundColor: Colors.teal[100],
                        child: Text(
                          widget.username[0].toUpperCase(),
                          textScaleFactor: 3,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showPicker(context);
                              },
                              child: Text('Change profile picture',
                                textAlign: TextAlign.start,
                                //style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold)
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.newImagePath.value = '';
                                  widget.oldImagePath = '';
                                  widget.oldImageRemoved.value = true;
                                });
                              },
                              child: Text('Remove current image',
                                textAlign: TextAlign.start,
                                //style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold)
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }
}



