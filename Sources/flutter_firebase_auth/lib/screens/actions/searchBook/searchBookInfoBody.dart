import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class SearchBookInfoBody extends StatelessWidget {

  final dynamic book;
  final dynamic bookInfo;

  final sectionContents = [];

  SearchBookInfoBody({Key key, this.book, this.bookInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;


    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Theme(
          data: Theme.of(context).copyWith(
              dividerColor: index == 2 ?
              Colors.transparent : Theme.of(context).dividerColor
          ),
          child: ExpansionTile(
              initiallyExpanded: false,
              title:
              index == 0 ?
                Text('Book general info', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),) :
              index == 1 ?
                Text('Sold by', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),):
                Text('Exchanged by', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),),
              children: <Widget>[
                index == 0 ?
                HomeBookGeneralInfoView(selectedBook: bookInfo,) :
                (
                  index == 1 ?
                    SoldByView(books: book, showOnlyExchangeable: false, fromPending: false,) :
                    SoldByView(books: book, showOnlyExchangeable: true, fromPending: false,)
                )
              ]
          ),
        );
      },
    );
  }
}
