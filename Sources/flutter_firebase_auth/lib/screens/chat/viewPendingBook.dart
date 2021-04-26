import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class ViewPendingBook extends StatelessWidget {

  final bool youGet;
  final dynamic book;
  final dynamic bookGeneralInfo;

  const ViewPendingBook({Key key, this.book, this.bookGeneralInfo, this.youGet}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(youGet ? 'Book you get' : 'Book you give', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          letterSpacing: 1.0,
        ),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeBookGeneralInfoView(
                selectedBook: bookGeneralInfo,
              ),
              //Divider(height: 10, thickness: 2.0, indent: _isTablet ? 50.0 : 12.0, endIndent: _isTablet ? 50.0 : 12.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _isTablet ? 20.0 : 8.0, vertical: _isTablet ? 40.0 : 16.0),
                child: Card(
                  color: Colors.white12,
                  child: SoldByView(
                    books: book,
                    showOnlyExchangeable: false,
                    fromPending: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
