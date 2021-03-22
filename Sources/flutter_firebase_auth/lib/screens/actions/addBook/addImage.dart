import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ImageService extends StatefulWidget {

  InsertedBook insertedBook;
  bool justView;

  ImageService({Key key, @required this.insertedBook, @required this.justView}) : super(key: key);

  @override
  _ImageServiceState createState() => _ImageServiceState();
}

class _ImageServiceState extends State<ImageService> {

  final ImagePicker _picker = ImagePicker();

  _imgFromCamera() async {
    PickedFile image = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50
    );

    if(image != null) {
      setState(() {
        widget.insertedBook.addImage(image.path);
        //print("Image inserted. Now there are ${widget.insertedBook.images.length}");
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
        widget.insertedBook.addImage(image.path);
        //print("Image inserted. Now there are ${widget.insertedBook.images.length}");
      });
    }
  }


  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.black,
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

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    var storage = StorageService();

    final listItem = widget.insertedBook.imagesPath != null ?
        widget.insertedBook.imagesPath
        /*
        List<ImageDisplay>.generate(
          widget.insertedBook.images.length,
          (index) => ImageDisplay(widget.insertedBook.images[index]))

         */
        : null;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            child: Column(
                children: [
                  Text(widget.justView ? "":"Insert here the images of your book", style: TextStyle(color: Colors.white),),
                  Flexible(
                    flex: 1,
                    child: SizedBox(height: 20.0,),
                  ),
                  !widget.justView && (listItem == null || listItem.length == 0 )? FloatingActionButton.extended(
                    heroTag: "addImageBtn",
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      _showPicker(context);
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text("Add images", style: TextStyle(color: Colors.white),),
                  ) : Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 1.0,
                            maxHeight: MediaQuery.of(context).size.height * 0.35,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listItem.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle
                                ),
                                padding: EdgeInsets.all(5.0),

                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Stack(
                                    children: [
                                      Image.file(
                                          File(listItem[index])
                                      ),
                                      widget.justView ? Container() : Positioned(
                                        top: 1,
                                        right: 1,
                                        child: IconButton(
                                          icon: Icon(Icons.cancel, color: Colors.white70,),
                                          onPressed: () {
                                            setState(() {
                                              widget.insertedBook.removeImage(index);
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );;
                            }),
                        ),
                      ),
                      widget.justView ? Container() : Expanded(
                          flex: 2,
                          child:  FloatingActionButton(
                            heroTag: "addPhotoBtn",
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.add_a_photo),
                            onPressed: () {
                              //TODO aggiungere un set state con loading?
                              _showPicker(context);
                            }
                          )
                      ),
                    ],
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }
}
