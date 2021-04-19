import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/services/database.dart';

import 'bookHomePageView.dart';

class MyBooksBookList extends StatelessWidget {

  final AuthService _auth = AuthService();
  final Map<int, dynamic> books;
  bool _isTablet;
  bool self;
  String userUid;

  MyBooksBookList({Key key, @required this.self, @required this.books, this.userUid}) : super(key: key);

  DatabaseService _db;
  CustomUser user;
  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _pushBookPage(int index, BuildContext context) async {
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
              fatherContext: context,
              isSell: false,
              self: self
            )
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;
    //print("IsLargeScreen? " + (_isTablet ? "True" : "False"));

    if (self) {
      user = CustomUser(Utils.mySelf.uid);
      _db = DatabaseService(user: user);
    } else {
      user = CustomUser(userUid);
      _db = DatabaseService(user: CustomUser(userUid));
    }

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(vertical: 36.0 * (_isTablet ? 3 : 1), horizontal: 24.0 * (_isTablet ? 5 : 1)),//2// columns
      mainAxisSpacing: 36.0 * (_isTablet ? 2.5 : 1),
      crossAxisSpacing: 36.0 * (_isTablet ? 4.5 : 1),
      scrollDirection: Axis.vertical,
      childAspectRatio: imageWidth / (imageHeight*1.1),
      children: List.generate(books.keys.length, (index) {
        return InkWell(
          onTapDown: _storePosition,
          onLongPress: () {
            if (self) {
              final RenderBox overlay = Overlay
                  .of(context)
                  .context
                  .findRenderObject();
              showMenu(
                context: context,
                color: Colors.grey[800],
                items: [
                  PopupMenuItem(
                    value: editBookPopupIndex,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(Icons.edit, color: Colors.white,),
                        ),
                        Text('Edit', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: deleteBookPopupIndex,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(
                            Icons.remove_circle, color: Colors.white,),
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
                if (value == editBookPopupIndex) {
                  InsertedBook book = await _db.getBook(index);
                  Reference bookRef = _db.storageService
                      .getBookDirectoryReference(user.uid, book);
                  List<String> bookPickedFilePaths = List<String>();
                  ListResult lr = await bookRef.listAll();
                  int count = 0;
                  for (Reference r in lr.items) {
                    try {
                      String filePath = await _db.storageService.toDownloadFile(
                          r, count);
                      if (filePath != null) {
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
                          builder: (newContext) =>
                              BookInsert(
                                insertedBook: book,
                                edit: true,
                                editIndex: index,
                                updateBook: null,
                              )
                      )
                  );
                }
                else if (value == deleteBookPopupIndex) {
                  print("Delete book");
                  InsertedBook book = await _db.getBook(index);
                  dynamic result = await _db.removeBook(index, book);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(duration: Duration(seconds: 1),
                      content: Text(
                        'Book removed: ' + '${book.title}',),
                      backgroundColor: Colors.white24,),
                  );
                }
              });
            }
          },
          onTap: () {
            _pushBookPage(index, context);
          },
          child: Card(
            elevation: 0.0,
            color: Colors.transparent,
            child: BookHomePageView(
              books: books,
              index: index,
              isTablet: _isTablet,
            ),
          ),
        );
      })
    );

  }

}
