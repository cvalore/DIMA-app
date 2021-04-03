import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class SoldByView extends StatelessWidget {

  final dynamic books;
  final bool showOnlyExchangeable;

  const SoldByView({Key key, this.books, this.showOnlyExchangeable}) : super(key: key);


  @override
  Widget build(BuildContext context) {
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
                                print("To profile of user " + books[i]['uid'].toString());
                              },
                              icon: Icon(Icons.person),
                            ),
                            IconButton(
                              splashRadius: 18.0,
                              onPressed: () {
                                print("To the book \"" + books[i]['book']['title'].toString() + "\" sold by user " + books[i]['uid'].toString());
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
