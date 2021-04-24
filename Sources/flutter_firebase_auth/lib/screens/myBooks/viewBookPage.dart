import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/comment.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/exchange.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/buyBooks.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:provider/provider.dart';

class ViewBookPage extends StatefulWidget {

  InsertedBook book;
  int index;
  bool hadImages;
  bool wasExchangeable;
  bool isSell;
  BuildContext fatherContext;
  bool self;
  String userUid;

  ViewBookPage({Key key, this.book, this.index, this.hadImages, this.isSell, this.wasExchangeable, this.fatherContext, this.self, this.userUid}) : super(key: key);

  @override
  _ViewBookPageState createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {

  void updateBook(InsertedBook updatedBook) {
    setState(() {
      widget.book = updatedBook;
    });
  }

  Widget trailingIconCategory = Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 36.0,);
  Widget trailingIconComment = Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 36.0,);
  Widget trailingIconPrice = Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 36.0,);

  @override
  Widget build(BuildContext context) {
    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(widget.book.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 0.5,
          ),
        ),
        actions: widget.isSell || !widget.self ? [] : <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              if(value == editBookPopupIndex) {
                print("Edit book");
                InsertedBook book = await _db.getBook(widget.index);
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
                        builder: (newContext) => BookInsert(
                          insertedBook: book,
                          edit: true,
                          editIndex: widget.index,
                          updateBook: updateBook,
                        )
                    )
                );
              }
              else if(value == deleteBookPopupIndex) {
                print("Delete book");
                //InsertedBook book = await _db.getBook(widget.index);
                dynamic result = await _db.removeBook(widget.index, widget.book);
                Navigator.pop(context);
                Scaffold.of(widget.fatherContext).showSnackBar(
                  SnackBar(duration: Duration(seconds: 1), content: Text(
                    'Book removed: ' + '${widget.book.title}',), backgroundColor: Colors.white24,),
                );
              }
            },
            color: Colors.white10,
            itemBuilder: (context) => [
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
                      child: Icon(Icons.remove_circle, color: Colors.white,),
                    ),
                    Text('Delete', style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: widget.isSell ?
          FloatingActionButton.extended(
            backgroundColor: Colors.white24,
            heroTag: "purchaseBtn",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (newContext) => BuyBooks(
                        booksToBuy: [widget.book],
                        sellingUserUid: widget.userUid,
                      )
                  )
              );
              print("TODO: --- Add to Cart");
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text("Buy"),
          ) :
          null,
      //backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,// - appBarHeight,
        padding: EdgeInsets.fromLTRB(_isTablet ? 150.0 : 20.0, _isTablet ? 40.0 : 0.0, _isTablet ? 150.0 : 20.0, _isTablet ? 40.0 : 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: [
              ImageService(insertedBook: widget.book, justView: true),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Status(insertedBook: widget.book, height: 50, offset: 50.0, justView: true),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Category(insertedBook: widget.book, height: 50, justView: true),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  trailing: trailingIconComment,
                  onExpansionChanged: (bool open) {
                    if(open) {
                      setState(() {
                        trailingIconComment = Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 36.0,);
                      });
                    }
                    else {
                      setState(() {
                        trailingIconComment = Icon(Icons.arrow_forward_ios, color: Colors.white);
                      });
                    }
                  },
                  title: Text("Comment",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  children: <Widget>[
                    widget.book.comment != null && widget.book.comment != '' ?
                    Text(
                      widget.book.comment,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ) :
                    Text('No comment available', style: TextStyle(fontStyle: FontStyle.italic),),
                  ],
                ),
              ),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Price(insertedBook: widget.book, height: 50, justView: true,),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Exchange(insertedBook: widget.book, height: 50, justView: true),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
