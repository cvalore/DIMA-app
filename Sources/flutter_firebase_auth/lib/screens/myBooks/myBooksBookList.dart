import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/services/database.dart';

class MyBooksBookList extends StatelessWidget {

  final AuthService _auth = AuthService();
  final Map<int, dynamic> books;

  MyBooksBookList({Key key, @required this.books}) : super(key: key);

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),//2// columns
      mainAxisSpacing: 25.0,
      scrollDirection: Axis.vertical,
      //itemCount: books.keys.length,
      //itemBuilder: (BuildContext context, int index) {
      children: List.generate(books.keys.length, (index) {
        return GestureDetector(
          onTapDown: _storePosition,
          onLongPress: () {
            final RenderBox overlay = Overlay.of(context).context.findRenderObject();
            showMenu(
              context: context,
              color: Colors.white10,
              items: [
                PopupMenuItem(
                  value: deleteBookPopupOnLongPressIndex,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.remove_circle, color: Colors.white,),
                      ),
                      Text('Delete', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ],
              position: RelativeRect.fromRect(
                _tapPosition & const Size(40, 40),
                Offset.zero & overlay.size
              ),
            ).then((value) async {
              if(value == deleteBookPopupOnLongPressIndex) {
                print("Delete book");
                InsertedBook book = await _db.getBook(index);
                dynamic result = await _db.removeBook(index, book);
                Scaffold.of(context).showSnackBar(
                  SnackBar(duration: Duration(seconds: 1), content: Text(
                    'Book removed: ' + '${book.title}',), backgroundColor: Colors.white24,),
                );
              }
            });
          },
          onTap: () async {
            InsertedBook book = await _db.getBook(index);
            bool hadImages = book.imagesUrl != null && book.imagesUrl.length != 0;
            bool wasExchangeable = book.exchangeable;
            Reference bookRef = _db.storageService.getBookDirectoryReference(user.uid, book);
            List<String> bookPickedFilePaths = List<String>();
            ListResult lr = await bookRef.listAll();
            int count = 0;
            for(Reference r in lr.items) {
              try {
                String filePath = await _db.storageService.toDownloadFile(r, count);
                if(filePath != null) {
                  bookPickedFilePaths.add(filePath);
                }
              } on FirebaseException catch (e) {
                e.toString();
              }
              count = count + 1;
            }
            book.imagesPath = bookPickedFilePaths;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => ViewBookPage(
                    book: book,
                    index: index,
                    hadImages: hadImages,
                    wasExchangeable: wasExchangeable,
                    edit: false,
                    justView: true,
                    fatherContext: context,
                  )
                )
            );
          },
          child: Center(
            child: Container(
              decoration: books[books.keys.elementAt(index)]['thumbnail'] != null &&
                  books[books.keys.elementAt(index)]['thumbnail'].toString() != "" ?
              null : BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/no_image_available.png"),
                    //fit: BoxFit.cover,
                  )
              ),
              height: imageHeight,
              width: imageWidth,
              child: books[books.keys.elementAt(index)]['thumbnail'] != null &&
                  books[books.keys.elementAt(index)]['thumbnail'].toString() != "" ?
              CachedNetworkImage(
                imageUrl: books[books.keys.elementAt(index)]['thumbnail'],
                placeholder: (context, url) => Loading(),
                //width: imageWidth,
                //height: imageHeight,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: imageWidth,
                    height: imageHeight,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        image: DecorationImage(
                          image: imageProvider,
                          //fit: BoxFit.cover,
                        )
                    ),
                  );
                },
                errorWidget: (context, url, error) => Icon(Icons.error),
              ) : Container(),
            ),
          ),
        );
      }),
    );

  }

}
