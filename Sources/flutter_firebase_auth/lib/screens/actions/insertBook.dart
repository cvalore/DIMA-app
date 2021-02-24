import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/inserted_book.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';
import 'package:provider/provider.dart';

class InsertBook extends StatefulWidget {
  @override
  _InsertBookState createState() => _InsertBookState();
}

class _InsertBookState extends State<InsertBook> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    DatabaseService _db = DatabaseService(uid: user.uid);
    String _title = '';
    String _author = '';
    String _dropdownValue = 'None';
    bool _loading = false;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    var fictions = BookGenres().getFictionGenres();
    var nonFictions = BookGenres().getNonFictionGenres();

    return Scaffold(
      appBar: AppBar(
        title: Text('Insert your book'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.check_outlined), onPressed: () {
                
          })
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(
                  flex: 1
              ),
              Expanded(
                flex: 4,
                child: TextFormField(
                  decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                  validator: (value) =>
                  (value.isEmpty | !value.contains('@') | !value.contains('.')) ?
                  'Enter a valid email' : null,
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                ),
              ),
              Spacer(
                  flex: 1
              ),
              Expanded(
                flex: 4,
                child: TextFormField(
                  decoration: inputFieldDecoration.copyWith(hintText: 'Author'),
                  onChanged: (value) {
                    setState(() {
                      _author = value;
                    });
                  },
                ),
              ),
              Spacer(
                  flex: 2
              ),
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
                          child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                          onPressed: () async {
                            if(_formKey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });

                              var book = InsertedBook(title:_title, author: _author);
                              dynamic result = await _db.addUserBook(book, true);
                              if(result == null) {
                                setState(() {
                                  print("Not a valid email or already registered");
                                 // _error = 'Not a valid email or already registered';
                                  _loading = false;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      Spacer(
                          flex: 1
                      ),
                    ],
                  )
              ),
              Expanded(
                flex: 3,
                child: Text('AAAAAAAAAAAAAAAAAA', style: TextStyle(color: Colors.red[400], fontSize: 14),),
              ),
              Spacer(
                  flex: 1
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account?'),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Text('Sign in',
                          style: TextStyle(color: Colors.blue[600])),
                      onPressed: () {
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Text('or'),
              ),
              Expanded(
                flex: 4,
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Text('Continue anonymously..',
                      style: TextStyle(color: Colors.blue[600])),
                  onPressed: () async {
                  },
                ),
              ),
              Spacer(
                  flex: 1
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*
Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            //leading: const Icon(Icons.person),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
          ),
          ListTile(
            //leading: const Icon(Icons.phone),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Author",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: height/32, horizontal: width/12),  //approximate choice of proportions
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: height/22,    //approximate choice of proportions
              elevation: 16,
              //style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                //color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                dropdownValue = newValue;
                });
              },
              items: nonFictions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
 */




/*
            leading: const Icon(Icons.email),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          new ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Nick'),
            subtitle: const Text('None'),
          ),
          new ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Birthday'),
            subtitle: const Text('February 20, 1980'),
          ),
          new ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Contact group'),
            subtitle: const Text('Not specified'),
          )
        ],
      ),
    );
  }
}
 */

/*
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert your book'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: inputFieldDecoration.copyWith(hintText: 'Email'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (user != null) {
                    //Navigator.push()
                  }
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/