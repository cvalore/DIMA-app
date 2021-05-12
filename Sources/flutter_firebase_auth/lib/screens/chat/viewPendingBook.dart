import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/loading.dart';

class ViewPendingBook extends StatefulWidget {

  final bool youGet;
  final dynamic book;
  final dynamic bookGeneralInfo;

  const ViewPendingBook({Key key, this.book, this.bookGeneralInfo, this.youGet}) : super(key: key);

  @override
  _ViewPendingBookState createState() => _ViewPendingBookState();
}

class _ViewPendingBookState extends State<ViewPendingBook> {

  bool loading = false;

  void setLoading(bool newValue) {
    setState(() {
      loading = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(widget.youGet ? 'Book you get' : 'Book you give', style: TextStyle(
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
                selectedBook: widget.bookGeneralInfo,
              ),
              //Divider(height: 10, thickness: 2.0, indent: _isTablet ? 50.0 : 12.0, endIndent: _isTablet ? 50.0 : 12.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _isTablet ? 20.0 : 8.0, vertical: _isTablet ? 40.0 : 16.0),
                child: Card(
                  color: Colors.white12,
                  child: SoldByView(
                    books: widget.book,
                    showOnlyExchangeable: false,
                    fromPending: true,
                    setLoading: setLoading,
                    fatherContext: context,
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
