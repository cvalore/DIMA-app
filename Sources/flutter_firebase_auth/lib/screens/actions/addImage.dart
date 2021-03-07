import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


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
    
    final listItem = List<ImageDisplay>.generate(images.length, (index) => ImageDisplay(images[index]));
    return  Scaffold(
      appBar: AppBar(
        title: Text("Inserted pictures"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo), onPressed: () {
              _showPicker(context);
          })
        ],
      ),
      body: listItem.length == 0 ? Text(
        "nothing to show here"
      ) : ListView.builder(
        itemCount: listItem.length,
        itemBuilder: (context, index) {
          final item = listItem[index];
          
          return item.buildImage(context);
        }),
    );
  }

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
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.file(
                File(_imageFile.path)
            ),
          ],
        ),
      );
  }
}
