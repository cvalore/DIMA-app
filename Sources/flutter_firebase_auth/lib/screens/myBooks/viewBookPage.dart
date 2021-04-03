import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:provider/provider.dart';

class ViewBookPage extends StatefulWidget {

  InsertedBook book;
  int index;
  bool hadImages;
  bool wasExchangeable;
  bool justView;
  bool edit;
  bool sell;
  BuildContext fatherContext;

  ViewBookPage({Key key, this.book, this.index, this.hadImages, this.sell, this.wasExchangeable, this.justView, this.edit, this.fatherContext}) : super(key: key);

  @override
  _ViewBookPageState createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {

  @override
  Widget build(BuildContext context) {
    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

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
        actions: widget.edit || widget.sell ? [] : <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              if(value == editBookPopupIndex) {
                print("Edit book");
                setState(() {
                  widget.justView = false;
                  widget.edit = true;
                });
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
      floatingActionButton: widget.edit ? FloatingActionButton.extended(
        backgroundColor: Colors.white24,
        heroTag: "editSaveBtn",
        onPressed: () async {
          await _db.updateBook(widget.book, widget.index, widget.hadImages, widget.wasExchangeable);
          final snackBar = SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'Book updated successfully',
            ),
            backgroundColor: Colors.white24,
          );
          Navigator.pop(context);
          Scaffold.of(widget.fatherContext).showSnackBar(snackBar);
        },
        icon: Icon(Icons.save),
        label: Text("Save"),
      ) : (
        widget.sell ?
          FloatingActionButton.extended(
            backgroundColor: Colors.white24,
            heroTag: "addToCartBtn",
            onPressed: () {
              print("TODO: --- Add to Cart");
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text("Add to Cart"),
          ) :
          null
      ),
      //backgroundColor: Colors.black,
      body: AddBookUserInfo(
        insertedBook: widget.book,
        edit: widget.edit,
        justView: widget.justView,
      ),
    );
  }
}
