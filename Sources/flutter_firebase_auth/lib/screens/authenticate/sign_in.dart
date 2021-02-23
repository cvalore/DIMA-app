import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String _email = '';
  String _password = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold (
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: Text('Sign in to BookYourBook'),
      ),
      body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
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
                    flex:2
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
                          child: Text('Sign In', style: TextStyle(color: Colors.white),),
                          onPressed: () async {
                            if(_formKey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });

                              dynamic result = await _auth.signInEmailPassword(_email, _password);
                              if(result == null) {
                                setState(() {
                                  print("Wrong username or password");
                                  _error = 'Wrong username or password';
                                  _loading = false;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(_error, style: TextStyle(color: Colors.red[400], fontSize: 14),),
                  ),
                  Spacer(
                      flex:1
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Spacer(
                          flex: 1
                        ),
                        Expanded(
                          flex: 20,
                          child: Text('Don\'t have an account yet?'),
                        ),
                        Expanded(
                          flex: 10,
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            ),
                            child: Text('Create account',
                                style: TextStyle(color: Colors.blue[600])),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                        ),
                        Spacer(
                            flex: 1
                        ),
                      ],
                    ),
                  ),
                  Spacer(
                      flex:2
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('or'),
                  ),
                  Spacer(
                      flex:1
                  ),
                  Expanded(
                    flex: 5,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('Sign in with google'),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        dynamic result = await _auth.signInGoogle();
                        if(result == null) {
                          print('Google sign in failed');
                        }
                      },
                    ),
                  ),
                  Spacer(
                      flex:1
                  ),
                  Expanded(
                  flex: 3,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('You can also '),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          ),
                          child: Text('continue anonymously',
                              style: TextStyle(color: Colors.blue[600])),
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });

                            await _auth.signInAnonymously().then((result) {
                              if(result == null) {
                                setState(() {
                                  _loading = false;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Spacer(
                      flex:1
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
