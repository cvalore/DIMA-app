import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';


class Category extends StatefulWidget {

  InsertedBook insertedBook;
  double height;
  bool justView;

  Category({Key key, @required this.insertedBook, @required this.height, @required this.justView}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
        child: GestureDetector(
          onTap: () async {
            if(!widget.justView) {
              dynamic result = await Navigator.pushNamed(
                  context, CategoryBox.routeName,
                  arguments: widget.insertedBook.category);
              setState(() {
                if (result != null)
                  widget.insertedBook.setCategory(result);
              });
            }
          },
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Category",
                            style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      widget.insertedBook.category != null ?
                        Expanded(
                            flex: 3,
                            child: Text(
                              widget.insertedBook.category,
                              textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white),)) :
                        Container(),
                    ],
                  )
              ),
              widget.justView ? Container() : Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            ],
          ),
        ),
    );
  }
}


class CategoryBox extends StatefulWidget {
  static const routeName = '/categoryBox';

  @override
  _CategoryBoxState createState() => _CategoryBoxState();
}

class _CategoryBoxState extends State<CategoryBox> {

  String chosenGenre;
  List<String> genres = BookGenres().allBookGenres;


  @override
  Widget build(BuildContext context) {

    chosenGenre = ModalRoute.of(context).settings.arguments != null ?
            ModalRoute.of(context).settings.arguments : '';

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        title: Text("Categories"),
      ),
      //backgroundColor: Colors.black,
      body: Theme(
        data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.white,
            disabledColor: Colors.white10,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: _isTablet ? 30.0 : 0.0),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.white,
                indent: _isTablet ? 150.0 : 15.0,
                endIndent: _isTablet ? 150.0 : 15.0,
              );
            },
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: _isTablet ? 150.0 : 0.0),
                child: RadioListTile(
                  activeColor: Colors.white,
                  title: Text(genre, style: TextStyle(color: Colors.white),),
                  value: genre,
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: chosenGenre,
                  onChanged: (value) {
                    setState(() {
                      chosenGenre = value;
                    });
                    Navigator.pop(context, chosenGenre);
                  },
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}

