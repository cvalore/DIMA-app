import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';


class SoldByView extends StatefulWidget {

  final dynamic books;
  final bool showOnlyExchangeable;

  const SoldByView({Key key, this.books, this.showOnlyExchangeable}) : super(key: key);

  @override
  _SoldByViewState createState() => _SoldByViewState();
}

class _SoldByViewState extends State<SoldByView> {
  @override
  Widget build(BuildContext context) {
    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
          children: [
            for(int i = 0; i < widget.books.length; i++)
              if(!widget.showOnlyExchangeable || widget.books[i]['book']['exchangeable'] == true)
                InkWell(
                  onTap: () async {
                    Utils.pushBookPage(context, widget.books[i]['book'], widget.books[i]['uid']);
                  },
                  child: Column(
                      children: <Widget>[
                        i == 0 ? Container() : SizedBox(height: 25.0,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (widget.books[i]['uid'] != Utils.mySelf.uid) {
                                    DatabaseService databaseService = DatabaseService(
                                        user: CustomUser(widget.books[i]['uid']));
                                    CustomUser user = await databaseService
                                        .getUserSnapshot();
                                    BookPerGenreUserMap userBooks = await databaseService
                                        .getUserBooksPerGenreSnapshot();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            VisualizeProfileMainPage(
                                                user: user,
                                                books: userBooks.result,
                                                self: false)
                                        )
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => StreamProvider<CustomUser>.value(
                                            value: Utils.databaseService.userInfo,
                                            child: VisualizeProfileMainPage(self: true))
                                        )
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.brown.shade800,
                                      radius: 25.0,
                                      child: widget.books[i]['userProfileImageURL'] != null &&
                                          widget.books[i]['userProfileImageURL'].toString().isNotEmpty ?
                                      CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: NetworkImage(widget.books[i]['userProfileImageURL']),
                                        //FileImage(File(user.userProfileImagePath))
                                      ) : Text(
                                        widget.books[i]['username'][0].toUpperCase(),
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(widget.books[i]['username'].toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                                          Text(widget.books[i]['email'].toString(),
                                            style: TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('€ ' + widget.books[i]['book']['price'].toStringAsFixed(2)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Exchange available'),
                                            widget.books[i]['book']['exchangeable'] == true ? Icon(Icons.check_outlined, color: Colors.green) :
                                            Icon(Icons.clear_outlined, color: Colors.red),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 30.0),
                                    IconButton(
                                      onPressed: () async {
                                        if (widget.books[i]['uid'] !=
                                            Utils.mySelf.uid) {
                                          DatabaseService databaseService = DatabaseService(
                                              user: CustomUser(
                                                  widget.books[i]['uid']));
                                          if (widget.books[i]['book']['likedBy']
                                              .contains(Utils.mySelf.uid)) {
                                            await databaseService.removeLike(
                                                widget
                                                    .books[i]['book']['insertionNumber'],
                                                Utils.mySelf.uid);
                                            setState(() {
                                              widget.books[i]['book']['likedBy']
                                                  .remove(Utils.mySelf.uid);
                                            });
                                          } else {
                                            await databaseService.addLike(widget
                                                .books[i]['book']['insertionNumber'],
                                                Utils.mySelf.uid);
                                            setState(() {
                                              widget.books[i]['book']['likedBy']
                                                  .add(Utils.mySelf.uid);
                                            });
                                          }
                                        }
                                      },
                                      splashRadius: 10.0,
                                      icon: widget.books[i]['book']['likedBy'].contains(Utils.mySelf.uid) ?
                                      Icon(Icons.favorite_outlined, color: Colors.red,) : Icon(Icons.favorite_border_outlined, color: Colors.red,),
                                    ),
                                    Text(widget.books[i]['book']['likedBy'].length.toString())
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          /*decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                    ),*/
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 1.0,
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: widget.books[i]['book']['imagesUrl'].length > 0 ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.books[i]['book']['imagesUrl'].length,
                              itemBuilder: (context, imageIndex) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Container(
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 0.5)),
                                    width: MediaQuery.of(context).size.height * 0.3 * imageWidth/imageHeight,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.books[i]['book']['imagesUrl'][imageIndex],
                                      placeholder: (context, url) => Loading(),
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                );
                              }
                          ) : Text("NO IMAGES", style: TextStyle(fontStyle: FontStyle.italic),),
                        ),
                        SizedBox(height: 25.0,),
                        Divider(height: 1.0, thickness: 1.0, indent: 5, endIndent: 5, color: Colors.white,),
                      ]
                  ),
                )
          ]
      ),
    );
  }
}