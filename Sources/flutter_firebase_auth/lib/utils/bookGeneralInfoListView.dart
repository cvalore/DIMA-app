import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class BookGeneralInfoListView extends StatelessWidget {

  final dynamic selectedBook;

  const BookGeneralInfoListView({Key key, this.selectedBook}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return ListView(
      children: <Widget>[
        Text(selectedBook.title, textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
        Text('by ' + selectedBook.author, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0), textAlign: TextAlign.center,),
        Text(''),
        ((selectedBook.publisher != null) & (selectedBook.publishedDate != null)) ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(selectedBook.publisher + ' ' + selectedBook.publishedDate, textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
            Text(''),
          ],
        ) : Container(),
        selectedBook.thumbnail != null ?
        CachedNetworkImage(
          imageUrl: selectedBook.thumbnail,
          placeholder: (context, url) => Loading(),
          width: imageWidth,
          height: imageHeight,
        ) :
        Container(),
        Text(''),
        Text('Description', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
        selectedBook.description != null ?
        Text(selectedBook.description, textAlign: TextAlign.justify, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),) :
        Text('No description provided', style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0), textAlign: TextAlign.center,),
        Text(''),
        /*
                      Text('ISBN 10', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(booksAPI.getISBN10(selectedBook['volumeInfo']) ?? ''),
                      Text(''),
                       */
        selectedBook.isbn13 != null ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('ISBN 13', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
            Text(selectedBook.isbn13, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
          ],
        ) : Container(),
        Text(''),
        selectedBook.pageCount != null ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Page count', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
            Text(selectedBook.pageCount.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
          ],
        ) : Container(),
        Text(''),
        selectedBook.categories != null ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Categories', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
            Text(selectedBook.categories.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0)),
          ],
        ) : Container(),
        Text(''),
        selectedBook.averageRating != null ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Average rating', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(selectedBook.averageRating.floor().toString(), style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
                Text('  '),
                for(var i = 0; i < 5 && selectedBook.averageRating != null; i++)
                  Icon(i > selectedBook.averageRating - 1 ?
                  Icons.star_border : Icons.star,
                      size: 15.0,
                      color: Colors.yellow[700]),
              ],
            ),
          ],
        ) : Container(),
        Text(''),
        selectedBook.ratingsCount != null ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Ratings count', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
            Text(selectedBook.ratingsCount.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0)),
          ],
        ) : Container(),
        Text(''),
        selectedBook.language != null ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Language', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
            Text(selectedBook.language.toString().toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19.0 : 15.0),),
          ],
        ) : Container(),
        Text(''),
      ],
    );
  }
}
