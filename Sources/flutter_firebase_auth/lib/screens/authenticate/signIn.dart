import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/authenticate/subscribe.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';


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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Sign in to BookYourBook'),
      ),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
            child: Form(
              key: _formKey,
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Spacer(
                    flex: 1
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        contentPadding: EdgeInsets.only(top: 25.0),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17.0,),
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
                    cursorColor: Colors.black,
                    //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      contentPadding: EdgeInsets.only(top: 25.0),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 17.0,),
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
                                    return Colors.white10;
                                  }
                                  else {
                                    return Colors.white24;
                                  }
                                }),
                          ),
                          child: Text('Sign In',
                            style: TextStyle(color: Colors.white),
                            ),
                          onPressed: () {
                            _signinWithEmailAndPassword(context);
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
                          child: Text('Don\'t have an account yet?', style: TextStyle(color: Colors.white),),
                        ),
                        Expanded(
                          flex: 10,
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            ),
                            child: Text('Create account',
                                style: TextStyle(color: Colors.red[600])),
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
                    child: Text('or', style: TextStyle(color: Colors.white),),
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
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white10;
                              }
                              else {
                                return Colors.white24;
                              }
                            }),
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
                              child: Text('Sign in with google', style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        _signWithGoogle(context);
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
                        Text('You can also ', style: TextStyle(color: Colors.white),),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          ),
                          child: Text('continue anonymously',
                              style: TextStyle(color: Colors.red[600])),
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


  _signinWithEmailAndPassword(BuildContext context) async {
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
  }

  _signWithGoogle(BuildContext context) async {
      final result = await _auth.signInGoogle();
      if(result == null) {
        print('Google sign in failed');
      } else if (!result['alreadyExists']) {
        final username = await Navigator.pushNamed(context, Subscribe.routeName) as String;
        print(username);
        if (username != null) {
          dynamic signupResult = await _auth.signUpGoogle(
              result['authCredentials'], result['email'],
              username);
          if (signupResult == null) {
            print('Google sign in failed');
          }
        }
      }
  }
}
