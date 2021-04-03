import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class HomeBookGeneralInfoView extends StatelessWidget {
  final dynamic selectedBook;

  const HomeBookGeneralInfoView({Key key, this.selectedBook}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Text(selectedBook["title"], textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
          Text('by ' + selectedBook["author"], style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: _isTablet ? 17.0 : 13.0), textAlign: TextAlign.center,),
          Text(''),
          ((selectedBook["publisher"] != null) & (selectedBook["publishedDate"] != null)) ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(selectedBook["publisher"] + ' ' + selectedBook["publishedDate"], textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: _isTablet ? 17.0 : 13.0),),
              Text(''),
            ],
          ) : Container(),
          selectedBook["thumbnail"] != null ?
          CachedNetworkImage(
            imageUrl: selectedBook["thumbnail"],
            placeholder: (context, url) => Loading(),
            width: imageWidth,
            height: imageHeight,
          ) :
          Container(),
          Text(''),
          Text('Description', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
          selectedBook["summary"] != null ?
          Text(selectedBook["summary"], textAlign: TextAlign.justify, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),) :
          Text('No description provided', style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0), textAlign: TextAlign.center,),
          Text(''),
          selectedBook["isbn"] != null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('ISBN 13', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Text(selectedBook["isbn"], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Text('')
            ],
          ) : Container(),
          selectedBook["pageCount"] != null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Page count', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Text(selectedBook["pageCount"].toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Text(''),
            ],
          ) : Container(),
          selectedBook["categories"] != null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Categories', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Text(selectedBook["categories"].toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0)),
              Text(''),
            ],
          ) : Container(),
          selectedBook["ratingsCount"] != null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Average rating', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(selectedBook["ratingsCount"].floor().toString(), style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
                  Text('  '),
                  for(var i = 0; i < 5 && selectedBook["ratingsCount"] != null; i++)
                    Icon(i > selectedBook["ratingsCount"] - 1 ?
                    Icons.star_border : Icons.star,
                        size: 15.0,
                        color: Colors.yellow[700]),
                ],
              ),
              Text(''),
            ],
          ) : Container(),
          /*selectedBook["ratingsCount"] != null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Ratings count', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Text(selectedBook["ratingsCount"].toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0)),
              Text(''),
            ],
          ) : Container(),*/
          selectedBook["language"] != null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Language', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
              Text(selectedBook["language"].toString().toUpperCase(), textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: _isTablet ? 18.0 : 14.0),),
            ],
          ) : Container(),
        ],
      ),
    );
  }
}
