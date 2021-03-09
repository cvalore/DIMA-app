import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ImageService extends StatefulWidget {
  @override
  _ImageServiceState createState() => _ImageServiceState();
}

class _ImageServiceState extends State<ImageService> {

  List<PickedFile> images = List<PickedFile>();
  final ImagePicker _picker = ImagePicker();

  _imgFromCamera() async {
    PickedFile image = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50
    );

    if(image != null) {
      setState(() {
        images.add(image);
        print("Image inserted. Now there are ${images.length}");
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
        images.add(image);
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
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
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
    CustomUser user = Provider.of<CustomUser>(context);
    DatabaseService _db = DatabaseService(user: user);
    var storage = StorageService();

    final listItem = List<ImageDisplay>.generate(
        images.length, (index) => ImageDisplay(images[index]));

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
                  Text("Insert here the images of your book"),
                  listItem.length == 0 ? FloatingActionButton.extended(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      _showPicker(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add images"),
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
                              final item = listItem[index];
                              return item.buildImage(context);
                            }),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child:  FloatingActionButton(
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




/*

      return Container(
              child: listItem.length == 0 ? Container(
                  constraints: BoxConstraints(
                    maxWidth: 100,
                    maxHeight: 100,
                  ),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                      onPressed: () {
                        _showPicker(context);
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add images"),
                    )
              )
              : Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                          itemCount: listItem.length,
                          itemBuilder: (context, index) {
                            final item = listItem[index];

                            return item.buildImage(context);
                          }),
                    ),
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: 1000,
                          maxHeight: 100,
                        ),
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.black,
                          onPressed: () {
                            //TODO aggiungere un set state con loading?
                            storage.addBookPictures("bookTitle", images);
                          },
                          icon: Icon(Icons.add),
                          label: Text("Save images"),
                        )
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.check_outlined),
                      onPressed: () {
                        //TODO aggiungere un set state con loading?
                        _showPicker(context);
                      }
                    )
                  ],
            )
    );
  }
*/

/*
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Row(
          children: <Widget>[
            Spacer(
                flex: 1
            ),
            Expanded(
              flex: 5,
              child: TextButton(
                  style: ButtonStyle(
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
                  child: Text(
                    "Add image",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                  {
                    _showPicker(context)
                  }
              ),
            ),
            Spacer(
                flex: 1
            ),
          ],
        )
    );
  }

 */
}

class ImageDisplay {

  PickedFile _imageFile;

  ImageDisplay(this._imageFile);


  Widget buildImage(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle
      ),
      padding: EdgeInsets.all(5.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Image.file(
            File(_imageFile.path)
        ),
      ),
    );
  }

/*
  Widget buildImage(BuildContext context){
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle
        ),
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Image.file(
                File(_imageFile.path)
            ),
            )
          ],
        ),
      );
  }

 */

}
