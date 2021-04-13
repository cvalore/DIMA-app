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
import 'package:provider/provider.dart';

class SoldByView extends StatelessWidget {

  final dynamic books;
  final bool showOnlyExchangeable;

  const SoldByView({Key key, this.books, this.showOnlyExchangeable}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          for(int i = 0; i < books.length; i++)
            if(!showOnlyExchangeable || books[i]['book']['exchangeable'] == true)
            InkWell(
              onTap: () async {
                _pushBookPage(context, books[i]['book'], books[i]['uid']);
              },
              child: Column(
                children: <Widget>[
                  i == 0 ? Container() : SizedBox(height: 25.0,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (newContext) => StreamProvider<CustomUser>.value(
                                        value: DatabaseService(user: CustomUser(
                                          books[i]['uid'].toString(),
                                          email: books[i]['email'].toString(), //non dovrebbe importare
                                        )).userInfo,
                                        child: VisualizeProfileMainPage(self: false)
                                    )
                                )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.brown.shade800,
                                radius: 25.0,
                                child: books[i]['userProfileImageURL'] != '' ?
                                CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: NetworkImage(books[i]['userProfileImageURL']),
                                  //FileImage(File(user.userProfileImagePath))
                                ) : Text(
                                  books[i]['username'][0].toUpperCase(),
                                  textScaleFactor: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(books[i]['username'].toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                                    /*
                                    Text(" - €" + books[i]['book']['price'].toStringAsFixed(2),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
                                     */
                                    Text(books[i]['email'].toString(),
                                      style: TextStyle(fontSize: 14.0),),
                                    /*
                                    Text(books[i]['book']['exchangeable'] == true ? "Exchange available" : "",
                                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13.0),),
                                     */
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('€ ' + books[i]['book']['price'].toStringAsFixed(2)),
                            SizedBox(width: 30.0),
                            Text('Exchange available'),
                            books[i]['book']['exchangeable'] == true ? Icon(Icons.check_outlined, color: Colors.green) :
                            Icon(Icons.clear_outlined, color: Colors.red),
                          ],
                        ),
                      ),
                        /*
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: ,
                        )

                         */
                      ],
                    ),
                  ),
                  //SizedBox(height: 15.0,),
                  Container(
                    /*decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                    ),*/
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 1.0,
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: books[i]['book']['imagesUrl'].length > 0 ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books[i]['book']['imagesUrl'].length,
                        itemBuilder: (context, imageIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              //decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 0.5)),
                              width: MediaQuery.of(context).size.height * 0.3 * imageWidth/imageHeight,
                              child: CachedNetworkImage(
                                imageUrl: books[i]['book']['imagesUrl'][imageIndex],
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


  Future<void> _pushBookPage(BuildContext context, book, String userUid) async {
    InsertedBook bookToPush = InsertedBook(
      id: book['id'],
      title: book['title'],
      author: book['author'],
      isbn13: book['isbn'],
      status: book['status'],
      category: book['category'],
      imagesUrl: List.from(book['imagesUrl']),
      comment: book['comment'],
      insertionNumber: book['insertionNumber'],
      price: book['price'],
      exchangeable: book['exchangeable'],
    );
    Reference bookRef = DatabaseService().storageService.getBookDirectoryReference(userUid, bookToPush);
    List<String> bookPickedFilePaths = List<String>();
    ListResult lr = await bookRef.listAll();
    int count = 0;
    for(Reference r in lr.items) {
      try {
        String filePath = await DatabaseService().storageService.toDownloadFile(r, count);
        if(filePath != null) {
          bookPickedFilePaths.add(filePath);
        }
      } on FirebaseException catch (e) {
        e.toString();
      }
      count = count + 1;
    }
    bookToPush.imagesPath = bookPickedFilePaths;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (newContext) => ViewBookPage(
              book: bookToPush,
              isSell: true,
            )
        )
    );

  }
}