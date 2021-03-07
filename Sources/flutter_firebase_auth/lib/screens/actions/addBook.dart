import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addImage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';
import 'package:provider/provider.dart';
import 'addImage.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  @override
  Widget build(BuildContext context) {
    final AddBookParameters param = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[700],
          elevation: 0.0,
          title: Text('Insert book'),
          actions:
          <Widget>[
            IconButton(
                icon: param.isEditing ? const Icon(null) : const Icon(Icons.check_outlined), onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
            })
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: SnackBarPage(context),
    );
  }
}

class SnackBarPage extends StatefulWidget {

  final BuildContext context;

  SnackBarPage(this.context);

  @override
  _SnackBarPageState createState() => _SnackBarPageState();
}


class _SnackBarPageState extends State<SnackBarPage> {
  final _formKey = GlobalKey<FormState>();

  /*String _title = '';
  String _author = '';*/
  String _purpose = 'For Sale';
  bool _loading = false;
  final Map<String, List<String>> bookGenres = BookGenres().getGenres();
  String _fictOrNot = 'Fiction';
  String _genre = BookGenres().getGenres()['Fiction'][0];

  @override
  Widget build(BuildContext context) {
    final AddBookParameters param = ModalRoute.of(context).settings.arguments;

    CustomUser user = Provider.of<CustomUser>(context);
    DatabaseService _db = DatabaseService(user: user);
    var screenSize = MediaQuery
        .of(context)
        .size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(
                  flex: 1
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: param.editTitle,
                  decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                  validator: (value) =>
                  value.isEmpty ? 'Enter the book title' : null,
                  onChanged: (value) {
                    setState(() {
                      param.editTitle = value;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: param.editAuthor,
                  decoration: inputFieldDecoration.copyWith(hintText: 'Author'),
                  validator: (value) =>
                  value.isEmpty ? 'Enter the book author' : null,
                  onChanged: (value) {
                    setState(() {
                      param.editAuthor = value;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField(
                  value: _purpose,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: width/20,
                  elevation: 10,
                  onChanged: (String newvalue){
                    setState(() {
                      _purpose = newvalue;
                    });
                  },
                  items: <String>['For Sale', 'To Exchange']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField(
                  value: _fictOrNot,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: width/20,
                  elevation: 10,
                  onChanged: (String newvalue){
                    setState(() {
                      _fictOrNot = newvalue;
                      _genre = BookGenres().getGenres()[newvalue][0];
                    });
                  },
                  items: <String>['Fiction', 'Not Fiction']
                        .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  ),
                ),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField(
                  value: _genre,
                  icon: Icon(Icons.arrow_drop_down),
                  //hint: Text('Genre'),
                  validator: (value) =>
                    value == '___' ? 'Specifiy a genre for the book' : null,
                  iconSize: width/20,
                  elevation: 10,
                  onChanged: (String newvalue){
                    setState(() {
                      _genre = newvalue;
                    });
                  },
                  items: bookGenres[_fictOrNot]
                        .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                        }).toList(),
                    )
                ),
              ImageService(),
              Expanded(
                  flex: 3,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                          flex: 1
                      ),
                      Expanded(
                        flex: 5,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.blueGrey[400];
                                  }
                                  else {
                                    return Colors.blueGrey[600];
                                  }
                                }),
                          ),
                          child: Text(
                            param.isEditing ? 'Update book' : 'Add book',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              var book = InsertedBook(
                                  title: param.editTitle,
                                  author: param.editAuthor,
                                  genre: _genre,
                                  purpose: _purpose,
                                  fictOrNot: _fictOrNot
                              );
                              if (param.isEditing) {
                                dynamic result = await _db.updateBook(
                                    book, param.bookIndex);
                                if (result != null) {
                                  Navigator.pop(context);
                                }
                              }
                              else {
                                dynamic result = await _db.addUserBook(book);
                                if (result != null) {
                                  setState(() {
                                    param.editTitle = '';
                                    param.editAuthor = '';
                                    //_purpose = 'For Sale'; //Do not clear this
                                    _fictOrNot = 'Fiction';
                                    _genre =
                                    BookGenres().getGenres()['Fiction'][0];
                                  });
                                }
                              }
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(
                                    param.isEditing ?
                                    'The book has been successfully modified!' :
                                    'The book has been successfully added!'
                                ),
                                action: SnackBarAction(
                                  label: param.isEditing ? 'Modified' : 'Added',
                                  onPressed: () {
                                    //TODO aggiungere una funzione undo?
                                  },
                                ),
                              );
                              // Find the Scaffold in the widget tree and use
                              // it to show a SnackBar.
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          }
                        ),
                      ),
                      Spacer(
                          flex: 1
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
    );
  }





}