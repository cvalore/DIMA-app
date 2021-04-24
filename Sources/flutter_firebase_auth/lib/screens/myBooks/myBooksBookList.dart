import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/buyBooks.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/services/database.dart';

import 'bookHomePageView.dart';


class MyBooksBookList extends StatefulWidget {

  final Map<int, dynamic> books;
  bool _isTablet;
  bool self;
  String userUid;

  MyBooksBookList({Key key, @required this.self, @required this.books, this.userUid}) : super(key: key);

  @override
  _MyBooksBookListState createState() => _MyBooksBookListState();
}

class _MyBooksBookListState extends State<MyBooksBookList> {

  DatabaseService _db;
  CustomUser user;
  var _tapPosition;
  List<dynamic> booksSelectedToBuy = List<dynamic>();
  bool selectionModeOn = false;
  bool loading = false;
  List<bool> selectedBooks = List<bool>();

  @override
  void initState() {
    for(int i = 0; i < widget.books.length; i++)
      selectedBooks.add(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget._isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    if (widget.self) {
      user = CustomUser(Utils.mySelf.uid);
      _db = DatabaseService(user: user);
    } else {
      user = CustomUser(widget.userUid);
      _db = DatabaseService(user: CustomUser(widget.userUid));
    }

    return loading == true ? Loading() : Scaffold(
      floatingActionButton: widget.self == false ?
      selectionModeOn ? FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          _pushBuyItems(context);
        },
      ) : FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              if (selectionModeOn == false)
                selectionModeOn = true;
            });
          },
          label: Text('Buy items'),
          icon: Icon(Icons.shopping_cart_outlined))
          : Container(),
      body: Stack(
        children: [
          GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.fromLTRB(24.0 * (widget._isTablet ? 5 : 1), 36.0 * (widget._isTablet ? 3 : 1), 24.0 * (widget._isTablet ? 5 : 1), 36.0 * (widget._isTablet ? 3 : 2)),
              mainAxisSpacing: 36.0 * (widget._isTablet ? 2.5 : 1),
              crossAxisSpacing: 36.0 * (widget._isTablet ? 4.5 : 1),
              scrollDirection: Axis.vertical,
              childAspectRatio: imageWidth / (imageHeight*1.1),
              children: List.generate(widget.books.keys.length, (index) {
                return InkWell(
                  onTapDown: _storePosition,
                  onLongPress: () {
                    if (widget.self) {
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
                  child: InkWell(
                    onTap: selectionModeOn == false ? null : () {
                      setState(() {
                        selectedBooks[index] = !selectedBooks[index];
                      });
                    },
                    child: Card(
                      elevation: 0.0,
                      color: selectedBooks[index] == true ? Colors.lightBlue : Colors.transparent,
                      child: BookHomePageView(
                        books: widget.books,
                        index: index,
                        isTablet: widget._isTablet,
                      ),
                    ),
                  ),
                );
              })
          ),
          selectionModeOn == true ? Positioned(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                constraints: BoxConstraints(maxHeight: 40),
                child: Center(
                  child: Text(
                    'Select the items you want to buy',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
                  )
                ),
              ),
            ),
          ) : Container(),
          selectionModeOn == true ? Positioned(
              left: 20,
              bottom: 20,
              child: FloatingActionButton(
                child: Icon(Icons.cancel_outlined, size: 30),
                onPressed: () {
                  setState(() {
                    selectionModeOn = false;
                    for (int i = 0; i < selectedBooks.length; i++)
                      selectedBooks[i] = false;
                  });
                },
              )) : Container(),
        ],
      ),
    );

  }

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
                isSell: true,
                self: widget.self,
                userUid: widget.self ? null : widget.userUid
            )
        )
    );
  }

  Future<void> _pushBuyItems(BuildContext context) async {
    setState(() {
      loading = true;
    });
    List<InsertedBook> booksToBuy = List<InsertedBook>();
    InsertedBook book;
    for (int index = 0; index < selectedBooks.length; index++) {
      if (selectedBooks[index] == true) {
        book = await _db.getBook(index);
        bool hadImages = book.imagesUrl != null && book.imagesUrl.length != 0;
        Reference bookRef = _db.storageService.getBookDirectoryReference(
            user.uid, book);
        List<String> bookPickedFilePaths = List<String>();
        ListResult lr = await bookRef.listAll();
        int count = 0;
        for (Reference r in lr.items) {
          try {
            String filePath = await _db.storageService.toDownloadFile(r, count);
            if (filePath != null) {
              bookPickedFilePaths.add(filePath);
            }
          } on FirebaseException catch (e) {
            e.toString();
          }
          count = count + 1;
        }
        book.imagesPath = bookPickedFilePaths;
        booksToBuy.add(book);
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (newContext) =>
                BuyBooks(
                  booksToBuy: booksToBuy,
                  sellingUserUid: widget.userUid,
                )
        )
    );

    //reset normal conditions
    setState(() {
      for (int i = 0; i < selectedBooks.length; i++)
        selectedBooks[i] = false;
      loading = false;
      selectionModeOn = false;
    });
  }

}
