import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/services/database.dart';

class MyBooksBookList extends StatelessWidget {

  final AuthService _auth = AuthService();

  final Map<int, dynamic> books;

  MyBooksBookList({Key key, @required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    final DatabaseService _db = DatabaseService(user: user);

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),//2// columns
      mainAxisSpacing: 25.0,
      scrollDirection: Axis.vertical,
      //itemCount: books.keys.length,
      //itemBuilder: (BuildContext context, int index) {
      children: List.generate(books.keys.length, (index) {
        return GestureDetector(
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
                    builder: (newContext) =>
                        Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.black,
                            elevation: 0.0,
                            title: Text('BookYourBook', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              letterSpacing: 1.0,
                            ),),
                            actions: <Widget>[
                              TextButton.icon(
                                icon: Icon(Icons.logout, color: Colors.white,),
                                label: Text(''),
                                onPressed: () async {
                                  await _auth.signOut();
                                },
                              ),
                            ],
                          ),
                          backgroundColor: Colors.black,
                          floatingActionButton: FloatingActionButton.extended(
                            backgroundColor: Colors.white24,
                            heroTag: "editSaveBtn",
                            onPressed: () async {
                              await _db.updateBook(book, index, hadImages, wasExchangeable);
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(
                                  'Book updated successfully',
                                ),
                                backgroundColor: Colors.white24,
                              );
                              Navigator.pop(context);
                              // Find the Scaffold in the widget tree and use
                              // it to show a SnackBar.
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                            icon: Icon(Icons.save),
                            label: Text("Save"),
                          ),
                          body: AddBookUserInfo(
                            insertedBook: book,
                            edit: true,
                          ),
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
