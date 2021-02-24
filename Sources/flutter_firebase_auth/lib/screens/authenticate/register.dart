import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String _email = '';
  String _password = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: Text('Sign up to BookYourBook'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Spacer(
                        flex: 1
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        decoration: inputFieldDecoration.copyWith(hintText: 'Email'),
                        validator: (value) =>
                        (value.isEmpty | !value.contains('@') | !value.contains('.')) ?
                          'Enter a valid email' : null,
                        onChanged: (value) {
                          setState(() {
                            _email = value;
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
                          decoration: inputFieldDecoration.copyWith(hintText: 'Password'),
                          validator: (value) => value.length < 6 ?
                            'Enter password of at least 6 characters' : null,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          obscureText: true,
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
                                //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
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

                                  dynamic result = await _auth.signUpEmailPassword(_email, _password);
                                  if(result == null) {
                                    setState(() {
                                      print("Not a valid email or already registered");
                                      _error = 'Not a valid email or already registered';
                                      _loading = false;
                                    });
                                  } else {
                                    DatabaseService db = DatabaseService(uid: result.uid);
                                    await db.initializeUser();
                                    //TODO add some check?
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
                      child: Text(_error, style: TextStyle(color: Colors.red[400], fontSize: 14),),
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
                              widget.toggleView();
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
                          await _auth.signInAnonymously();
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
