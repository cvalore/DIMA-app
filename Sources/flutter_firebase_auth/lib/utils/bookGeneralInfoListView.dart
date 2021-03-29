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
        Text(selectedBook.title, textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
        Text('by ' + selectedBook.author, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: _isTablet ? 17.0 : 13.0), textAlign: TextAlign.center,),
        Text(''),
        ((selectedBook.publisher != null) & (selectedBook.publishedDate != null)) ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(selectedBook.publisher + ' ' + selectedBook.publishedDate, textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: _isTablet ? 17.0 : 13.0),),
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
        Text('Description', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
        selectedBook.description != null ?
        Text(selectedBook.description, textAlign: TextAlign.justify, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),) :
        Text('No description provided', style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0), textAlign: TextAlign.center,),
        Text(''),
        /*
                      Text('ISBN 10', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(booksAPI.getISBN10(selectedBook['volumeInfo']) ?? ''),
                      Text(''),
                       */
        selectedBook.isbn13 != null ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ISBN 13', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Text(selectedBook.isbn13, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Text('')
          ],
        ) : Container(),
        selectedBook.pageCount != null ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Page count', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Text(selectedBook.pageCount.toString(), style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Text(''),
          ],
        ) : Container(),
        selectedBook.categories != null ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Text(selectedBook.categories.toString(), style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0)),
            Text(''),
          ],
        ) : Container(),
        selectedBook.averageRating != null ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Average rating', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(selectedBook.averageRating.floor().toString(), style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
                Text('  '),
                for(var i = 0; i < 5 && selectedBook.averageRating != null; i++)
                  Icon(i > selectedBook.averageRating - 1 ?
                  Icons.star_border : Icons.star,
                      size: 15.0,
                      color: Colors.yellow[700]),
              ],
            ),
            Text(''),
          ],
        ) : Container(),
        selectedBook.ratingsCount != null ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ratings count', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Text(selectedBook.ratingsCount.toString(), style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0)),
            Text(''),
          ],
        ) : Container(),
        selectedBook.language != null ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Language', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            Text(selectedBook.language.toString().toUpperCase(), style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
          ],
        ) : Container(),
      ],
    );
  }
}
