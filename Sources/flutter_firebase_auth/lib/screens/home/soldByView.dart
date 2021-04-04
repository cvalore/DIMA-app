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
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          for(int i = 0; i < books.length; i++)
            if(!showOnlyExchangeable || books[i]['book']['exchangeable'] == true)
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(books[i]['username'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                          Text(books[i]['email'].toString(),
                            style: TextStyle(fontSize: 14.0),),
                          Text(books[i]['book']['exchangeable'] == true ? "Exchange available" : "",
                            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13.0),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              splashRadius: 18.0,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (newContext) => StreamProvider<CustomUser>.value(
                                            value: DatabaseService(user: CustomUser(
                                              books[i]['uid'].toString(),
                                              books[i]['email'].toString(), //non dovrebbe importare
                                              false, //non dovrebbe importare
                                            )).userInfo,
                                            child: VisualizeProfileMainPage(self: false)
                                        )
                                    )
                                );
                              },
                              icon: Icon(Icons.person),
                            ),
                            IconButton(
                              splashRadius: 18.0,
                              onPressed: () async {
                                InsertedBook book = InsertedBook(
                                  id: books[i]['book']['id'],
                                  title: books[i]['book']['title'],
                                  author: books[i]['book']['author'],
                                  isbn13: books[i]['book']['isbn'],
                                  status: books[i]['book']['status'],
                                  category: books[i]['book']['category'],
                                  imagesUrl: List.from(books[i]['book']['imagesUrl']),
                                  comment: books[i]['book']['comment'],
                                  insertionNumber: books[i]['book']['insertionNumber'],
                                  price: books[i]['book']['price'],
                                  exchangeable: books[i]['book']['exchangeable'],
                                );
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
                                          sell: true,
                                          justView: true,
                                          edit: false,
                                        )
                                    )
                                );
                              },
                              icon: Icon(Icons.subdirectory_arrow_right_rounded)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.0,),
                Container(
                  /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),*/
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 1.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: books[i]['book']['imagesUrl'].length > 0 ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books[i]['book']['imagesUrl'].length,
                      itemBuilder: (context, imageIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            //decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 0.5)),
                            width: MediaQuery.of(context).size.height * 0.5 * imageWidth/imageHeight,
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
                SizedBox(height: 25.0,),
              ]
            )
        ]
      ),
    );
  }
}
