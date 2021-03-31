import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class BookHomePageView extends StatelessWidget {

  final Map<int, dynamic> books;
  final int index;
  final bool isTablet;

  const BookHomePageView({Key key, this.books, this.index, this.isTablet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: books[books.keys.elementAt(index)]['thumbnail'] != null &&
                books[books.keys.elementAt(index)]['thumbnail'].toString() != "" ?
            null : BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                image: DecorationImage(
                  image: AssetImage("assets/images/no_image_available.png"),
                  fit: BoxFit.cover,
                )
            ),
            child: books[books.keys.elementAt(index)]['thumbnail'] != null &&
                books[books.keys.elementAt(index)]['thumbnail'].toString() != "" ?
            CachedNetworkImage(
              imageUrl: books[books.keys.elementAt(index)]['thumbnail'],
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
            ) : Container(),
          ),
        ),
        Center(
          child: Text(
            books[index]["title"],
            style: TextStyle(color: Colors.white, fontSize: isTablet ? 24 : 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Center(
          child: Text(
            books[index]["author"],
            style: TextStyle(color: Colors.white, fontSize: isTablet ? 20 : 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
