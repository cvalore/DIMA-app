import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
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
      });
    }
  }


  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              //color: Colors.black,
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

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
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

    return widget.justView && (listItem == null || listItem.length == 0 ) ?
    Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(vertical: 40.0),
      height: _isPortrait ? (MediaQuery.of(context).size.height / 2.7) : (MediaQuery.of(context).size.width / 2.7),
      child: Text(
        'NO IMAGE AVAILABLE',
        style: Theme.of(context).textTheme.headline6.copyWith(fontStyle: FontStyle.italic),
      ),
    ) : Container(
      //margin: EdgeInsets.all(10),
      //width: MediaQuery.of(context).size.width,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.4,
      child: !widget.justView && (listItem == null || listItem.length == 0 ) ?
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width / 10 * 4,
        child: FloatingActionButton.extended(
          heroTag: "addImageBtn",
          //backgroundColor: Colors.white24,
          //foregroundColor: Colors.black,
          onPressed: () {
            _showPicker(context);
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text("Add images", style: TextStyle(color: Colors.white),),
        ),
      ) : Stack(
          children: [
           ListView.builder(
             scrollDirection: Axis.horizontal,
             itemCount: listItem.length,
             itemBuilder: (context, index) {
               return Container(
                 decoration: BoxDecoration(
                     shape: BoxShape.rectangle
                 ),
                 //padding: EdgeInsets.all(5.0),
                 child: Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Stack(
                     children: [
                       InkWell(
                         onTap: () {
                           if (widget.justView) {
                             Navigator.push(
                                 context, MaterialPageRoute(builder: (_) {
                               return LargerImage(
                                   imagePath: listItem[index]);
                             }));
                           }
                         },
                         child: ClipRRect(
                           borderRadius : BorderRadius.circular(8.0),
                           child: Image.file(
                               File(listItem[index])
                           ),
                         ),
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
               );
             }),
          widget.justView ? Container() :
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                  heroTag: "addPhotoBtn",
                  backgroundColor: Theme.of(context).floatingActionButtonTheme.
                                    copyWith(backgroundColor: Colors.white24).backgroundColor.withOpacity(0.4),
                  child: Icon(Icons.add_a_photo, color: Colors.white),
                  onPressed: () {
                    _showPicker(context);
                  }
          ),
            ),
        ],
      ),
    );
  }
}



class LargerImage extends StatelessWidget {

  String imagePath;

  LargerImage({Key key, @required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          tag: 'viewBookPageHero',
          child: Container(
            //child: Image.network(widget.user.userProfileImageURL),
            //height: MediaQuery.of(context).size.height * 6/10,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.contain,
              ),
            ),
          )
        ),
      ),
    );
  }
}


